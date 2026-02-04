import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingSalaryStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingSalaryStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("💰", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            "Qual é sua renda mensal?",
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final cents = (double.tryParse(value) ?? 0 * 100).toInt();
              context.read<OnboardingViewModel>().updateSalary(cents);
            },
            decoration: const InputDecoration(
              hintText: "R\$ 0,00",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onNext,
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}
