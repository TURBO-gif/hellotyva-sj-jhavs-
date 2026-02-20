import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../models/resume_model.dart';
import '../services/ad_service.dart';
import '../services/pdf_service.dart';
import '../services/resume_provider.dart';
import '../templates/resume_template_mapper.dart';
import '../widgets/primary_button.dart';

class ResumePreviewScreen extends StatefulWidget {
  const ResumePreviewScreen({required this.resume, super.key});

  final ResumeModel resume;

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  final PdfService _pdfService = PdfService();
  InterstitialAd? _interstitialAd;
  bool _loadingAd = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitial();
  }

  void _loadInterstitial() {
    _loadingAd = true;
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _loadingAd = false;
        },
        onAdFailedToLoad: (_) {
          _loadingAd = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Resume Preview')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ResumeTemplateMapper.buildPreview(
                  resume: widget.resume,
                  templateId: widget.resume.templateId,
                  showWatermark: !provider.isPremium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Download PDF',
                    onPressed: () async {
                      final proceed = await _showAdIfNeeded(provider.isPremium);
                      if (!proceed) {
                        return;
                      }
                      final bytes = await _pdfService.generateResumePdf(
                        resume: widget.resume,
                        isPremium: provider.isPremium,
                      );
                      await _pdfService.downloadPdf(bytes);
                    },
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'Share',
                    onPressed: () async {
                      final bytes = await _pdfService.generateResumePdf(
                        resume: widget.resume,
                        isPremium: provider.isPremium,
                      );
                      await _pdfService.sharePdf(
                        bytes: bytes,
                        fileName: '${widget.resume.fullName}_resume.pdf',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showAdIfNeeded(bool isPremium) async {
    if (isPremium) {
      return true;
    }
    if (_loadingAd) {
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    if (_interstitialAd == null) {
      return true;
    }

    final completer = Completer<bool>();
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitial();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
    );
    _interstitialAd!.show();

    return completer.future;
  }
}
