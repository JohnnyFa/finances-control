import 'package:big_decimal/big_decimal.dart';

class Transaction {
  final int? id;
  BigDecimal amount;
  String type;
  String category;
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

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as int?,
    amount: json['amount'] as BigDecimal,
    type: json['type'] as String,
    category: json['category'] as String,
    date: DateTime.parse(json['date'] as String),
    description: json['description'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'type': type,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };
}
