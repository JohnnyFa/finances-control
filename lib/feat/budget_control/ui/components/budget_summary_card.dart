import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final int totalLimit;
  final int totalSpent;
  final double percentage;
  final int month;
  final int year;

  const BudgetSummaryCard({
    super.key,
    required this.totalLimit,
    required this.totalSpent,
    required this.percentage,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isOverBudget = totalSpent > totalLimit;
    final remaining = totalLimit - totalSpent;

    final statusColor = isOverBudget ? scheme.error : scheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: statusColor.withValues(alpha: 0.06),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isOverBudget ? context.appStrings.budget_exceeded : context.appStrings.within_budget,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),

              Text(
                '${_monthName(month)}/$year',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _ProgressSection(percentage: percentage, isOverBudget: isOverBudget),

          const SizedBox(height: 20),

          Column(
            children: [
              _AmountLine(
                label: context.appStrings.spent,
                amount: totalSpent,
                color: scheme.error,
              ),
              const SizedBox(height: 12),
              _AmountLine(
                label: context.appStrings.limit,
                amount: totalLimit,
                color: scheme.onSurface,
              ),
              const SizedBox(height: 12),
              _AmountLine(
                label: isOverBudget ? context.appStrings.exceeded : context.appStrings.remaining,
                amount: remaining.abs(),
                color: isOverBudget ? scheme.error : scheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _AmountLine({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          formatCurrencyFromCents(context, amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double percentage;
  final bool isOverBudget;

  const _ProgressSection({
    required this.percentage,
    required this.isOverBudget,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isOverBudget ? scheme.error : scheme.primary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appStrings.total_spent,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (percentage / 100).clamp(0, 1),
            minHeight: 12,
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];
  return months[month - 1];
}
