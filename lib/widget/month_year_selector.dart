import 'package:flutter/material.dart';

import 'custom_text.dart';

class MonthYearSelector extends StatefulWidget {
  final Function(DateTime date)? onChanged;

  const MonthYearSelector({super.key, this.onChanged});

  @override
  State<MonthYearSelector> createState() => _MonthYearSelectorState();
}

class _MonthYearSelectorState extends State<MonthYearSelector> {
  DateTime current = DateTime.now();

  final List<String> months = [
    "Janeiro","Fevereiro","Março","Abril","Maio","Junho",
    "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"
  ];

  void nextMonth() {
    setState(() {
      current = DateTime(current.year, current.month + 1);
    });

    widget.onChanged?.call(current);
  }

  void previousMonth() {
    setState(() {
      current = DateTime(current.year, current.month - 1);
    });

    widget.onChanged?.call(current);
  }

  @override
  Widget build(BuildContext context) {
    final monthName = months[current.month - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: previousMonth,
        ),

        CustomText(
          description: "$monthName ${current.year}",
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),

        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: nextMonth,
        ),
      ],
    );
  }
}
