import 'package:finances_control/design_system/design_system.dart';
import 'package:flutter/material.dart';

class DesignSystemShowcasePage extends StatefulWidget {
  const DesignSystemShowcasePage({super.key});

  @override
  State<DesignSystemShowcasePage> createState() =>
      _DesignSystemShowcasePageState();
}

class _DesignSystemShowcasePageState extends State<DesignSystemShowcasePage> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const DefaultHeader(
            title: 'Design System',
            subtitle: 'Shared components showcase',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CustomText(
                  description: 'Typography',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                CustomText(
                  description:
                      'This page renders shared components from lib/design_system.',
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 24),
                CustomText(
                  description: 'Inputs',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: 'Type your name',
                  controller: nameController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
