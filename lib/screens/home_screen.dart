import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/purchase_service.dart';
import '../services/resume_provider.dart';
import '../widgets/primary_button.dart';
import 'my_resumes_screen.dart';
import 'resume_form_screen.dart';
import 'templates_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();
    final purchaseService = context.read<PurchaseService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Resume Builder for Freshers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              label: 'Create Resume',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ResumeFormScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'My Resumes',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MyResumesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Templates',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TemplatesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              provider.isPremium
                  ? 'Premium unlocked: Ads removed, watermark removed.'
                  : 'Upgrade to Premium ₹59 (one-time) for no ads + premium templates.',
            ),
            if (!provider.isPremium) ...[
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Unlock Premium ₹59',
                onPressed: () => purchaseService.buyPremium(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
