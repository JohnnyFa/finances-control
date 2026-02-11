import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/info_card.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../widgets/onboarding_primary_button.dart';

class OnboardingHowItWorksStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingHowItWorksStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("📱", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),

          Text(
            strings.how_the_app_works,
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            strings.a_simple_and_easy_way,
            style: context.textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          infoCard(
            icon: "📊",
            title: strings.follow_your_expenses,
            subtitle: strings.see_everything_organized_by_category,
          ),

          infoCard(
            icon: "🔁",
            title: strings.recurring_expenses,
            subtitle: strings.sign_once_repeat_every_month,
          ),

          infoCard(
            icon: "🎯",
            title: strings.know_where_you_money_goes,
            subtitle: strings.simple_graphics_show_your_patterns,
          ),

          infoCard(
            icon: "📈",
            title: strings.clarity_your_monthly_balance,
            subtitle: strings.follow_your_monthly_balance
          ),

          const SizedBox(height: 32),

          OnboardingPrimaryButton(label: strings.continue_label, onPressed: onNext),
        ],
      ),
    );
  }
}
