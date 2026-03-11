import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class Transaction {
  final int? id;
  final String? externalId;
  int amount;
  TransactionType type;
  Category category;
  DateTime date;
  String description;

  final bool isGenerated;

  Transaction({
    this.id,
    this.externalId,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.description,
    this.isGenerated = false,
  });
}
