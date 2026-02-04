import 'package:finances_control/core/extensions/context_color_extension.dart';
import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingGoalStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingGoalStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingViewModel, OnboardingState>(
      builder: (context, state) {
        final goal = state.goalInCents / 100;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🏦", style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),

              Text(
                "Quanto você quer guardar por mês?",
                style: context.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                "Defina sua meta de economia",
                style: context.textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              Text(
                "R\$ ${goal.toStringAsFixed(0)}",
                style: context.textTheme.displaySmall?.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Slider(
                min: 0,
                max: 5000,
                divisions: 100,
                value: goal.clamp(0, 5000),
                onChanged: (value) {
                  context.read<OnboardingViewModel>().updateSalary(
                    (value * 100).toInt(),
                  );
                },
              ),

              const SizedBox(height: 8),

              Text(
                "🎯 Pode ser um valor fixo ou uma meta inicial",
                style: context.textTheme.bodySmall,
              ),

              const SizedBox(height: 32),

              ElevatedButton(onPressed: onNext, child: const Text("Continuar")),
            ],
          ),
        );
      },
    );
  }
}
