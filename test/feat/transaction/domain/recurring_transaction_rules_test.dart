import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isActiveForMonth', () {
    test('returns true when recurring is active in month window', () {
      final recurring = RecurringTransaction(
        amount: 1000,
        type: TransactionType.expense,
        category: Category.rent,
        dayOfMonth: 10,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        active: true,
        description: 'Rent',
      );

      expect(isActiveForMonth(recurring, 2026, 5), isTrue);
    });

    test('returns false when before start date month', () {
      final recurring = RecurringTransaction(
        amount: 1000,
        type: TransactionType.expense,
        category: Category.rent,
        dayOfMonth: 10,
        startDate: DateTime(2026, 4, 1),
        active: true,
        description: 'Rent',
      );

      expect(isActiveForMonth(recurring, 2026, 3), isFalse);
    });

    test('returns false when inactive even if date matches', () {
      final recurring = RecurringTransaction(
        amount: 1000,
        type: TransactionType.expense,
        category: Category.rent,
        dayOfMonth: 10,
        startDate: DateTime(2026, 1, 1),
        active: false,
        description: 'Rent',
      );

      expect(isActiveForMonth(recurring, 2026, 5), isFalse);
    });
  });
}
