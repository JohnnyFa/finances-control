import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/app_text_field.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/error_text.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_previous_button.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_primary_button.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class OnboardingSalaryStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const OnboardingSalaryStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return BlocBuilder<OnboardingViewModel, OnboardingState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("💰", style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),

                Text(
                  strings.amount_monthly,
                  style: context.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                AppTextField(
                  hintText: "R\$ 0,00",
                  inputFormatters: [CurrencyInputFormatter()],
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    final cents = int.tryParse(toNumericString(value)) ?? 0;
                    context.read<OnboardingViewModel>().updateSalary(cents);
                  },
                ),

                const SizedBox(height: 32),

                if (state.validationError != null && state.step == 1)
                  ErrorText(errorMessage: state.validationError!),

                const SizedBox(height: 16),

                OnboardingPrimaryButton(
                  label: strings.continue_label,
                  onPressed: onNext,
                ),

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
