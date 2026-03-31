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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Design System Showcase')),
      backgroundColor: scheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomText(
            description: 'Navigation',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 160,
              child: DefaultHeader(
                title: 'Default Header',
                subtitle: 'Showcase preview',
                onBack: () {},
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomText(
            description: 'Typography',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          const SizedBox(height: 8),
          CustomText(
            description:
                'This page renders shared components from lib/design_system.',
            fontSize: 14,
            color: scheme.onSurface,
          ),
          const SizedBox(height: 24),
          CustomText(
            description: 'Inputs',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          const SizedBox(height: 8),
          AppTextField(
            hintText: 'Type your name',
            controller: nameController,
          ),
        ],
      ),
    );
  }
}
