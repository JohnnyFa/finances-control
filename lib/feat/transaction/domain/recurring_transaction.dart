import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class RecurringTransaction {
  final int? id;
  final int amount;
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
}
