import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class Transaction {
  final int? id;
  int amount;
  TransactionType type;
  Category category;
  DateTime date;
  String description;

  Transaction({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.description,
  });
}
