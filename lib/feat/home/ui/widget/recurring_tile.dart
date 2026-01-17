import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

Widget recurringTile(BuildContext context, RecurringTransaction r) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(r.category.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                description: categoryLabel(context, r.category),
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                description: '${context.appStrings.every} ${r.dayOfMonth}',
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        CustomText(
          description: formatCurrencyFromCents(context, r.amount.toInt()),
          fontWeight: FontWeight.w600,
        ),
      ],
    ),
  );
}
