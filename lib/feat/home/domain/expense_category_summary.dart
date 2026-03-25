import 'package:finances_control/feat/transaction/domain/category.dart';

class ExpenseCategorySummary {
  final Category category;
  final int total;
  final int? limitCents;
  final double percentage;

  ExpenseCategorySummary({
    required this.category,
    required this.total,
    required this.percentage,
    this.limitCents,
  });
}