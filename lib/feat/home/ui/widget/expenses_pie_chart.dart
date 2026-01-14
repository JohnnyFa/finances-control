import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget expensesPieChart(
  BuildContext context,
  List<ExpenseCategorySummary> data,
) {
  return PieChart(
    PieChartData(
      sectionsSpace: 3,
      centerSpaceRadius: 50,
      sections: data.map((e) {
        return PieChartSectionData(
          value: e.percentage,
          color: e.category.color,
          showTitle: true,
          title: '${e.category.emoji}\n${e.percentage.toStringAsFixed(0)}%',
          radius: 45,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        );
      }).toList(),
    ),
  );
}
