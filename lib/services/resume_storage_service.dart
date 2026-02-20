import 'package:shared_preferences/shared_preferences.dart';

import '../models/resume_model.dart';

class ResumeStorageService {
  static const String _resumesKey = 'saved_resumes_v1';

  Future<List<ResumeModel>> loadResumes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_resumesKey) ?? <String>[];
    return raw.map(ResumeModel.fromJson).toList();
  }

  Future<void> saveResumes(List<ResumeModel> resumes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = resumes.map((resume) => resume.toJson()).toList();
    await prefs.setStringList(_resumesKey, encoded);
  }
}
