import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/resume_model.dart';
import '../services/resume_provider.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import 'resume_preview_screen.dart';

class ResumeFormScreen extends StatefulWidget {
  const ResumeFormScreen({super.key, this.existingResume});

  final ResumeModel? existingResume;

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _objectiveController;
  late final TextEditingController _educationController;
  late final TextEditingController _skillsController;
  late final TextEditingController _projectsController;
  late final TextEditingController _experienceController;

  int _selectedTemplateId = 1;

  @override
  void initState() {
    super.initState();
    final item = widget.existingResume;

    _fullNameController = TextEditingController(text: item?.fullName ?? '');
    _phoneController = TextEditingController(text: item?.phone ?? '');
    _emailController = TextEditingController(text: item?.email ?? '');
    _addressController = TextEditingController(text: item?.address ?? '');
    _objectiveController = TextEditingController(text: item?.objective ?? '');
    _educationController = TextEditingController(text: item?.education ?? '');
    _skillsController = TextEditingController(text: item?.skills.join(', ') ?? '');
    _projectsController = TextEditingController(text: item?.projects ?? '');
    _experienceController = TextEditingController(text: item?.experience ?? '');
    _selectedTemplateId = item?.templateId ?? 1;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _objectiveController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _projectsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Resume Form')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle('Personal Information'),
              _input(_fullNameController, 'Full Name'),
              _input(_phoneController, 'Phone'),
              _input(_emailController, 'Email'),
              _input(_addressController, 'Address', maxLines: 2),
              const SectionTitle('Career Objective'),
              _input(_objectiveController, 'Objective', maxLines: 3),
              const SectionTitle('Education'),
              _input(_educationController, 'Education', maxLines: 3),
              const SectionTitle('Skills (comma separated)'),
              _input(_skillsController, 'Skills'),
              const SectionTitle('Projects'),
              _input(_projectsController, 'Projects', maxLines: 3),
              const SectionTitle('Experience'),
              _input(_experienceController, 'Experience', maxLines: 3),
              const SectionTitle('Template'),
              DropdownButtonFormField<int>(
                value: _selectedTemplateId,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Template 1: Basic (Free)')),
                  DropdownMenuItem(value: 2, child: Text('Template 2: Modern (Premium)')),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Template 3: Professional (Premium)'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  if (!provider.canUseTemplate(value)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unlock Premium to use this template.'),
                      ),
                    );
                    return;
                  }
                  setState(() => _selectedTemplateId = value);
                },
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: widget.existingResume == null ? 'Save Resume' : 'Update Resume',
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final resume = ResumeModel(
                    id: widget.existingResume?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    fullName: _fullNameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    email: _emailController.text.trim(),
                    address: _addressController.text.trim(),
                    objective: _objectiveController.text.trim(),
                    education: _educationController.text.trim(),
                    skills: _skillsController.text
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList(growable: false),
                    projects: _projectsController.text.trim(),
                    experience: _experienceController.text.trim(),
                    templateId: _selectedTemplateId,
                    createdAt: widget.existingResume?.createdAt ?? DateTime.now(),
                  );

                  if (widget.existingResume == null) {
                    await context.read<ResumeProvider>().addResume(resume);
                  } else {
                    await context.read<ResumeProvider>().updateResume(resume);
                  }

                  if (!mounted) {
                    return;
                  }

                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResumePreviewScreen(resume: resume),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (!provider.isPremium) const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
