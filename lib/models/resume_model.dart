import 'dart:convert';

class ResumeModel {
  ResumeModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.objective,
    required this.education,
    required this.skills,
    required this.projects,
    required this.experience,
    required this.templateId,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String objective;
  final String education;
  final List<String> skills;
  final String projects;
  final String experience;
  final int templateId;
  final DateTime createdAt;

  ResumeModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? address,
    String? objective,
    String? education,
    List<String>? skills,
    String? projects,
    String? experience,
    int? templateId,
    DateTime? createdAt,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      objective: objective ?? this.objective,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      experience: experience ?? this.experience,
      templateId: templateId ?? this.templateId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'objective': objective,
      'education': education,
      'skills': skills,
      'projects': projects,
      'experience': experience,
      'templateId': templateId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      objective: map['objective'] as String? ?? '',
      education: map['education'] as String? ?? '',
      skills: List<String>.from(map['skills'] as List<dynamic>? ?? <dynamic>[]),
      projects: map['projects'] as String? ?? '',
      experience: map['experience'] as String? ?? '',
      templateId: map['templateId'] as int? ?? 1,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ResumeModel.fromJson(String source) =>
      ResumeModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
