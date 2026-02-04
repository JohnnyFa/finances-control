import 'package:finances_control/feat/onboarding/ui/widgets/error_text.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_primary_button.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingNameStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingNameStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<OnboardingViewModel, OnboardingState>(
            buildWhen: (prev, curr) =>
                prev.validationError != curr.validationError ||
                prev.name != curr.name,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("👋", style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),

                  const Text(
                    "Olá! Como podemos te chamar?",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Vamos personalizar sua experiência",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: TextField(
                      onChanged: (value) {
                        context.read<OnboardingViewModel>().updateName(value);
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Digite seu nome",
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.dividerColor,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (state.validationError != null && state.step == 0)
                    ErrorText(errorMessage: state.validationError!),

                  const SizedBox(height: 40),

                  OnboardingPrimaryButton(label: 'Continuar', onPressed: onNext),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
