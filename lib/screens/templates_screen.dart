import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/resume_provider.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _templateTile(
            context: context,
            id: 1,
            name: 'Template 1: Basic',
            premium: false,
            unlocked: true,
          ),
          _templateTile(
            context: context,
            id: 2,
            name: 'Template 2: Modern',
            premium: true,
            unlocked: provider.isPremium,
          ),
          _templateTile(
            context: context,
            id: 3,
            name: 'Template 3: Professional',
            premium: true,
            unlocked: provider.isPremium,
          ),
        ],
      ),
    );
  }

  Widget _templateTile({
    required BuildContext context,
    required int id,
    required String name,
    required bool premium,
    required bool unlocked,
  }) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          premium ? (unlocked ? 'Premium Unlocked' : 'Premium Only') : 'Free',
        ),
        trailing: Icon(
          unlocked ? Icons.check_circle : Icons.lock,
          color: unlocked ? Colors.black : Colors.black54,
        ),
      ),
    );
  }
}
