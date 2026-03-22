import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/budget_control/ui/components/expense_category_tile.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryList extends StatelessWidget {
  final List<ExpenseCategorySummary> categories;

  const ExpenseCategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((e) {
        return ExpenseCategoryTile(
          category: e.category,
          percent: e.percentage.round(),
          amount: formatCurrencyFromCents(context, e.total),
        );
      }).toList(),
    );
  }
}