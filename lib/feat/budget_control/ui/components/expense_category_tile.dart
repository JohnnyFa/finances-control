import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryTile extends StatelessWidget {
  final Category category;
  final int percent;
  final String amount;

  const ExpenseCategoryTile({
    super.key,
    required this.category,
    required this.percent,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surface,
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: CustomText(
                  description: categoryLabel(context, category),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              CustomText(
                description: '$percent%',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: category.color,
              ),
            ],
          ),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              description: amount,
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          // 🔥 READY FOR BUDGET BAR (future)
          // if (hasLimit) BudgetProgressBar(...)
        ],
      ),
    );
  }
}
