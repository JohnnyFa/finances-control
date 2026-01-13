import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/feat/transaction/data/transaction_entity.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class TransactionMapper {
  static TransactionEntity toEntity(Transaction tx) {
    return TransactionEntity(
      id: tx.id,
      amount: tx.amount.toString(),
      type: tx.type,
      category: tx.category,
      date: tx.date.toIso8601String(),
      description: tx.description,
    );
  }

  static Transaction toDomain(TransactionEntity entity) {
    return Transaction(
      id: entity.id,
      amount: BigDecimal.parse(entity.amount),
      type: entity.type,
      category: entity.category,
      date: DateTime.parse(entity.date),
      description: entity.description,
    );
  }
}
