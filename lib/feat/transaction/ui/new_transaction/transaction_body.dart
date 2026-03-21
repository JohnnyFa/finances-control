import 'package:flutter/material.dart';

class TransactionBody extends StatelessWidget {
  final Widget amount;
  final Widget typeSelector;
  final Widget category;
  final Widget date;
  final Widget recurringToggle;
  final Widget recurringSection;
  final Widget description;

  const TransactionBody({
    super.key,
    required this.amount,
    required this.typeSelector,
    required this.category,
    required this.date,
    required this.recurringToggle,
    required this.recurringSection,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        amount,
        const SizedBox(height: 14),
        typeSelector,
        const SizedBox(height: 14),
        category,
        const SizedBox(height: 14),
        date,
        const SizedBox(height: 14),
        recurringToggle,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: recurringSection,
        ),
        const SizedBox(height: 14),
        description,
      ],
    );
  }
}