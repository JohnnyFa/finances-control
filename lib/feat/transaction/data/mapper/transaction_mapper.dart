import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/feat/transaction/data/mapper/enum_transaction_mapper.dart';
import 'package:finances_control/feat/transaction/data/transaction_entity.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class TransactionMapper {
  static TransactionEntity toEntity(Transaction tx) {
    return TransactionEntity(
      id: tx.id,
      amount: tx.amount.toInt(),
      type: EnumTransactionMapper.transactionTypeToDb(tx.type),
      category: EnumTransactionMapper.categoryToDb(tx.category),
      date: tx.date.toIso8601String(),
      description: tx.description,
      year: tx.date.year,
      month: tx.date.month,
    );
  }

  static Transaction toDomain(TransactionEntity entity) {
    return Transaction(
      id: entity.id,
      amount: BigDecimal.parse((entity.amount / 100).toStringAsFixed(2)),
      type: EnumTransactionMapper.transactionTypeFromDb(entity.type),
      category: EnumTransactionMapper.categoryFromDb(entity.category),
      date: DateTime.parse(entity.date),
      description: entity.description,
    );
  }
}
