import 'package:finances_control/feat/onboarding/ui/widgets/app_text_field.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/error_text.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_primary_button.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingNameStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingNameStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;

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

                  Text(
                    strings.how_can_we_call_you,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    strings.lets_customize_your_experience,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  AppTextField(
                    hintText: strings.type_your_name,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      context.read<OnboardingViewModel>().updateName(value);
                    },
                  ),

                  if (state.validationError != null && state.step == 0)
                    ErrorText(errorMessage: state.validationError!),

                  const SizedBox(height: 40),

                  OnboardingPrimaryButton(
                    label: strings.continue_label,
                    onPressed: onNext,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
