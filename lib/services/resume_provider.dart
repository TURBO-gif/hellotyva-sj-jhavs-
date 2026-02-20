import 'package:flutter/material.dart';

import '../models/resume_model.dart';
import 'purchase_service.dart';
import 'resume_storage_service.dart';

class ResumeProvider extends ChangeNotifier {
  ResumeProvider({
    required ResumeStorageService storageService,
    required PurchaseService purchaseService,
  })  : _storageService = storageService,
        _purchaseService = purchaseService {
    _purchaseService.isPremium.addListener(notifyListeners);
  }

  final ResumeStorageService _storageService;
  final PurchaseService _purchaseService;

  List<ResumeModel> _resumes = <ResumeModel>[];

  List<ResumeModel> get resumes => _resumes;
  bool get isPremium => _purchaseService.isPremium.value;

  Future<void> loadResumes() async {
    _resumes = await _storageService.loadResumes();
    notifyListeners();
  }

  Future<void> addResume(ResumeModel resume) async {
    _resumes = <ResumeModel>[resume, ..._resumes];
    await _storageService.saveResumes(_resumes);
    notifyListeners();
  }

  Future<void> updateResume(ResumeModel resume) async {
    _resumes = _resumes
        .map((item) => item.id == resume.id ? resume : item)
        .toList(growable: false);
    await _storageService.saveResumes(_resumes);
    notifyListeners();
  }

  Future<void> deleteResume(String id) async {
    _resumes = _resumes.where((item) => item.id != id).toList(growable: false);
    await _storageService.saveResumes(_resumes);
    notifyListeners();
  }

  bool canUseTemplate(int templateId) {
    return templateId == 1 || isPremium;
  }

  @override
  void dispose() {
    _purchaseService.isPremium.removeListener(notifyListeners);
    super.dispose();
  }
}
