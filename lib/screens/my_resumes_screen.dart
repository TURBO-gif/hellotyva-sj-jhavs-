import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/resume_provider.dart';
import 'resume_form_screen.dart';
import 'resume_preview_screen.dart';

class MyResumesScreen extends StatelessWidget {
  const MyResumesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: provider.resumes.isEmpty
          ? const Center(child: Text('No resumes yet.'))
          : ListView.builder(
              itemCount: provider.resumes.length,
              itemBuilder: (context, index) {
                final resume = provider.resumes[index];
                return ListTile(
                  title: Text(resume.fullName.isEmpty ? 'Untitled Resume' : resume.fullName),
                  subtitle: Text('Template ${resume.templateId}'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResumePreviewScreen(resume: resume),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ResumeFormScreen(existingResume: resume),
                          ),
                        );
                      }
                      if (value == 'delete') {
                        await provider.deleteResume(resume.id);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
