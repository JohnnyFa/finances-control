import 'package:finances_control/core/formatters/date_formatter.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

class MonthYearSelector extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime>? onChanged;

  const MonthYearSelector({super.key, required this.date, this.onChanged});

  void _next() {
    onChanged?.call(DateTime(date.year, date.month + 1));
  }

  void _previous() {
    onChanged?.call(DateTime(date.year, date.month - 1));
  }

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormatter.monthYear(context, date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previous),
        CustomText(
          description: monthYear,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: _next),
      ],
    );
  }
}
