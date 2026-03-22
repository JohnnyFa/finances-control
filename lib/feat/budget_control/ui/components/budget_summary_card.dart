import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double totalLimit;
  final double totalSpent;

  const BudgetSummaryCard({
    super.key,
    required this.totalLimit,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = totalLimit - totalSpent;
    final isSafe = remaining >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSafe
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
      ),
      child: Row(
        children: [
          Text(isSafe ? "✅" : "⚠️", style: const TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              isSafe ? "Dentro do limite" : "Acima do limite",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            formatCurrencyFromCents(context, remaining.toInt()),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isSafe ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
