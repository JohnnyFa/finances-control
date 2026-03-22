import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categoryColor = budget.category.color;

    final percentage = budget.percentage;
    final progress = budget.progress;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(budget.category.name),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),

        background: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: scheme.error,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),

        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          budget.category.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.category.label(context.appStrings),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatCurrencyFromCents(context, budget.spentCents)} ${context.appStrings.of_preposition} ${formatCurrencyFromCents(context, budget.limitCents)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: scheme.outlineVariant.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation(categoryColor),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (budget.isOverBudget) ...[
                      const Icon(
                        Icons.warning_rounded,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      budget.isOverBudget
                          ? '${context.appStrings.exceeded_amount} ${formatCurrencyFromCents(context, budget.exceededCents)}'
                          : '${context.appStrings.remaining_amount} ${formatCurrencyFromCents(context, budget.remainingCents)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: budget.isOverBudget ? Colors.red : categoryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  context.appStrings.swipe_to_delete,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
