import 'package:finances_control/core/extensions/context_color_extension.dart';
import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/error_text.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_previous_button.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_primary_button.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingGoalStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const OnboardingGoalStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingViewModel, OnboardingState>(
      builder: (context, state) {
        final goal = state.goalInCents / 100;

        return Center(
          child: SingleChildScrollView(
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
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                Text(
                  "R\$ ${goal.toStringAsFixed(0)}",
                  style: context.textTheme.displaySmall?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Slider(
                  min: 0,
                  max: 5000,
                  divisions: 100,
                  value: goal.clamp(0, 5000),
                  onChanged: (value) {
                    context.read<OnboardingViewModel>().updateGoal(
                      (value * 100).toInt(),
                    );
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  "🎯 Pode ser um valor fixo ou uma meta inicial",
                  style: context.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                if (state.validationError != null && state.step == 2)
                  ErrorText(errorMessage: state.validationError!),

                const SizedBox(height: 16),

                OnboardingPrimaryButton(label: 'Continuar', onPressed: onNext),

                const SizedBox(height: 12),

                OnboardingPreviousButton(onPressed: onPrevious),
              ],
            ),
          ),
        );
      },
    );
  }
}
