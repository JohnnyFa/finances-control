import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';

class ExpenseCategorySummary {
  final Category category;
  final BigDecimal total;
  final double percentage;

  ExpenseCategorySummary({
    required this.category,
    required this.total,
    required this.percentage,
  });
}
