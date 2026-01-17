import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class RecurringTransaction {
  final int? id;
  final BigDecimal amount;
  final TransactionType type;
  final Category category;
  final int dayOfMonth;
  final DateTime startDate;
  final String description;
  final bool active;
  final DateTime? endDate;

  RecurringTransaction({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.dayOfMonth,
    required this.startDate,
    required this.description,
    required this.active,
    this.endDate,
  });

  bool isActiveForMonth(int year, int month) {
    final monthDate = DateTime(year, month);

    final started = !monthDate.isBefore(
      DateTime(startDate.year, startDate.month),
    );

    final notEnded =
        endDate == null ||
        monthDate.isBefore(DateTime(endDate!.year, endDate!.month + 1));

    return active && started && notEnded;
  }
}
