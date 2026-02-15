import 'package:finances_control/feat/home/ui/widget/section/balance_section.dart';
import 'package:finances_control/feat/home/ui/widget/section/recurring_section.dart';
import 'package:flutter/material.dart';

import 'widget/section/expenses_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, -30),
          child: const BalanceSection(),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: const ExpensesSection(),
        ),
        const RecurringSection(),
        const SizedBox(height: 100),
      ],
    );
  }
}
