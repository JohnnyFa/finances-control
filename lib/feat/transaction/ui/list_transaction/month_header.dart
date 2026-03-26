import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  final DateTime month;
  final int totalCents;

  const MonthHeader({
    super.key,
    required this.month,
    required this.totalCents,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isPositive = totalCents >= 0;

    final monthName = DateFormat('MMMM yyyy', 'pt_BR').format(month);
    final capitalizedMonth =
        monthName[0].toUpperCase() + monthName.substring(1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              capitalizedMonth,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${formatCurrencyFromCents(context, totalCents.abs())}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isPositive ? const Color(0xFF14AE5C) : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}