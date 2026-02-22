import 'package:finances_control/feat/transaction/data/mapper/transaction_mapper.dart';
import 'package:finances_control/feat/transaction/data/transaction/entity/transaction_entity.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionMapper', () {
    test('toEntity maps domain fields', () {
      final date = DateTime(2026, 3, 20, 8);
      final tx = Transaction(
        id: 1,
        amount: 12345,
        type: TransactionType.expense,
        category: Category.shopping,
        date: date,
        description: 'Mall',
      );

      final entity = TransactionMapper.toEntity(tx);

      expect(entity.id, 1);
      expect(entity.amount, 12345);
      expect(entity.type, 'expense');
      expect(entity.category, 'shopping');
      expect(entity.year, 2026);
      expect(entity.month, 3);
    });

    test('toDomain maps entity fields', () {
      final entity = TransactionEntity(
        id: 9,
        amount: 5000,
        type: 'income',
        category: 'freelance',
        date: DateTime(2026, 4, 10).toIso8601String(),
        description: 'Project',
        year: 2026,
        month: 4,
      );

      final tx = TransactionMapper.toDomain(entity);

      expect(tx.id, 9);
      expect(tx.amount, 5000);
      expect(tx.type, TransactionType.income);
      expect(tx.category, Category.freelance);
      expect(tx.description, 'Project');
    });
  });
}
