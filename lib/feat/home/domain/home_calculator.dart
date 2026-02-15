import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/domain/home_calculator_result.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction_rules.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class HomeCalculator {
  HomeCalculationResult calculate({
    required List<Transaction> transactions,
    required List<RecurringTransaction> recurring,
    required int year,
    required int month,
  }) {
    final recurringTransactions = _materializeRecurring(recurring, year, month);

    final allTransactions = [...transactions, ...recurringTransactions];

    int totalIncome = 0;
    int totalExpense = 0;
    final Map<Category, int> expenseTotals = {};

    for (final tx in allTransactions) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;

        expenseTotals.update(
          tx.category,
          (value) => value + tx.amount,
          ifAbsent: () => tx.amount,
        );
      }
    }

    final summaries = _buildExpenseSummaries(expenseTotals, totalExpense);

    final recurringForMonth = _filterRecurringForMonth(recurring, year, month);

    return HomeCalculationResult(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      summaries: summaries,
      recurringForMonth: recurringForMonth,
    );
  }

  List<ExpenseCategorySummary> _buildExpenseSummaries(
    Map<Category, int> expenseTotals,
    int totalExpense,
  ) {
    return expenseTotals.entries.map((e) {
      final double percentage = totalExpense == 0
          ? 0.0
          : (e.value / totalExpense) * 100;

      return ExpenseCategorySummary(
        category: e.key,
        total: e.value,
        percentage: percentage,
      );
    }).toList()..sort((a, b) => b.total.compareTo(a.total));
  }

  List<Transaction> _materializeRecurring(
    List<RecurringTransaction> recurring,
    int year,
    int month,
  ) {
    return recurring
        .where((r) => isActiveForMonth(r, year, month))
        .map(
          (r) => Transaction(
            amount: r.amount,
            type: r.type,
            category: r.category,
            date: DateTime(year, month, r.dayOfMonth),
            description: r.description,
          ),
        )
        .toList();
  }

  List<RecurringTransaction> _filterRecurringForMonth(
    List<RecurringTransaction> recurring,
    int year,
    int month,
  ) {
    return recurring.where((r) => isActiveForMonth(r, year, month)).toList();
  }
}
