import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeCalculator.calculate', () {
    test('returns totals and category summaries with budget limits', () {
      final calculator = HomeCalculator();

      final result = calculator.calculate(
        year: 2026,
        month: 4,
        transactions: [
          Transaction(
            amount: 500000,
            type: TransactionType.income,
            category: Category.salary,
            date: DateTime(2026, 4, 1),
            description: 'Salary',
          ),
          Transaction(
            amount: 10000,
            type: TransactionType.expense,
            category: Category.food,
            date: DateTime(2026, 4, 3),
            description: 'Lunch',
          ),
          Transaction(
            amount: 6000,
            type: TransactionType.expense,
            category: Category.transport,
            date: DateTime(2026, 4, 5),
            description: 'Bus',
          ),
        ],
        recurring: [
          RecurringTransaction(
            amount: 2000,
            type: TransactionType.expense,
            category: Category.food,
            dayOfMonth: 10,
            startDate: DateTime(2026, 1, 10),
            description: 'Coffee subscription',
            active: true,
          ),
        ],
        budgets: [
          Budget(
            category: Category.food,
            limitCents: 20000,
            spentCents: 0,
            month: 4,
            year: 2026,
          ),
        ],
      );

      expect(result.totalIncome, 500000);
      expect(result.totalExpense, 18000);
      expect(result.recurringForMonth.length, 1);

      final food = result.summaries.firstWhere((s) => s.category == Category.food);
      expect(food.total, 12000);
      expect(food.limitCents, 20000);
      expect(food.percentage, closeTo(66.666, 0.01));

      final transport = result.summaries.firstWhere((s) => s.category == Category.transport);
      expect(transport.total, 6000);
      expect(transport.limitCents, isNull);
      expect(transport.percentage, closeTo(33.333, 0.01));
    });

    test('ignores inactive recurring transactions for selected month', () {
      final calculator = HomeCalculator();

      final result = calculator.calculate(
        year: 2026,
        month: 4,
        transactions: const [],
        recurring: [
          RecurringTransaction(
            amount: 10000,
            type: TransactionType.expense,
            category: Category.rent,
            dayOfMonth: 1,
            startDate: DateTime(2026, 1, 1),
            description: 'Old rent',
            active: false,
          ),
        ],
        budgets: const [],
      );

      expect(result.totalIncome, 0);
      expect(result.totalExpense, 0);
      expect(result.summaries, isEmpty);
      expect(result.recurringForMonth, isEmpty);
    });
  });
}
