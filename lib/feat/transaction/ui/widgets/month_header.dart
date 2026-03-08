import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  final DateTime month;
  final int totalCents;

  const MonthHeader({required this.month, required this.totalCents});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final monthLabel = DateFormat.yMMMM(
      Localizations.localeOf(context).toString(),
    ).format(month);

    final isPositive = totalCents >= 0;

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              monthLabel,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: scheme.onSurface,
              ),
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${formatCurrencyFromCents(context, totalCents.abs())}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isPositive ? const Color(0xFF14AE5C) : scheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
