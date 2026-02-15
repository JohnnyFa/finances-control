import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

Widget incomeExpenseCard(
    BuildContext context,
    String title,
    int value, {
      required bool isIncome,
    }) {
  final scheme = Theme.of(context).colorScheme;

  final accentColor = isIncome
      ? scheme.primary
      : scheme.error;

  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            description: title,
            fontSize: 12,
            color: scheme.onTertiary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 6),
          CustomText(
            description: formatCurrencyFromCents(context, value),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ],
      ),
    ),
  );
}