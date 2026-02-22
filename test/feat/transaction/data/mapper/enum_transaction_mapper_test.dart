import 'package:finances_control/feat/transaction/data/mapper/enum_transaction_mapper.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnumTransactionMapper', () {
    test('maps category to/from db', () {
      final dbValue = EnumTransactionMapper.categoryToDb(Category.food);
      final category = EnumTransactionMapper.categoryFromDb('FoOd');

      expect(dbValue, 'food');
      expect(category, Category.food);
    });

    test('maps transaction type to/from db', () {
      final dbValue = EnumTransactionMapper.transactionTypeToDb(TransactionType.income);
      final type = EnumTransactionMapper.transactionTypeFromDb('ExPeNsE');

      expect(dbValue, 'income');
      expect(type, TransactionType.expense);
    });
  });
}
