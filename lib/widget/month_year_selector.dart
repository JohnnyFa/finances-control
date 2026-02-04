import 'package:flutter/material.dart';

import 'custom_text.dart';

class MonthYearSelector extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime>? onChanged;

  const MonthYearSelector({
    super.key,
    required this.date,
    this.onChanged,
  });

  static const List<String> months = [
    "Janeiro","Fevereiro","Março","Abril","Maio","Junho",
    "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"
  ];

  void _next() {
    onChanged?.call(DateTime(date.year, date.month + 1));
  }

  void _previous() {
    onChanged?.call(DateTime(date.year, date.month - 1));
  }

  @override
  Widget build(BuildContext context) {
    final monthName = months[date.month - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previous,
        ),
        CustomText(
          description: "$monthName ${date.year}",
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _next,
        ),
      ],
    );
  }
}