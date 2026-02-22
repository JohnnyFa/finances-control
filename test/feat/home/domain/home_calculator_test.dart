import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeCalculator', () {
    final calculator = HomeCalculator();

    test('calculates totals including recurring transactions for active month', () {
      final transactions = [
        Transaction(
          amount: 100000,
          type: TransactionType.income,
          category: Category.salary,
          date: DateTime(2026, 1, 5),
          description: 'Salary',
        ),
        Transaction(
          amount: 20000,
          type: TransactionType.expense,
          category: Category.food,
          date: DateTime(2026, 1, 10),
          description: 'Groceries',
        ),
      ];

      final recurring = [
        RecurringTransaction(
          amount: 5000,
          type: TransactionType.expense,
          category: Category.transport,
          dayOfMonth: 15,
          startDate: DateTime(2025, 12, 1),
          active: true,
          description: 'Bus pass',
        ),
      ];

      final result = calculator.calculate(
        transactions: transactions,
        recurring: recurring,
        year: 2026,
        month: 1,
      );

      expect(result.totalIncome, 100000);
      expect(result.totalExpense, 25000);
      expect(result.recurringForMonth.length, 1);
      expect(result.summaries.length, 2);
    });

    test('sorts expense summaries by total descending', () {
      final transactions = [
        Transaction(
          amount: 10000,
          type: TransactionType.expense,
          category: Category.food,
          date: DateTime(2026, 2, 1),
          description: '',
        ),
        Transaction(
          amount: 20000,
          type: TransactionType.expense,
          category: Category.rent,
          date: DateTime(2026, 2, 2),
          description: '',
        ),
      ];

      final result = calculator.calculate(
        transactions: transactions,
        recurring: const [],
        year: 2026,
        month: 2,
      );

      expect(result.summaries.first.category, Category.rent);
      expect(result.summaries.first.percentage, closeTo(66.66, 0.1));
    });
  });
}
