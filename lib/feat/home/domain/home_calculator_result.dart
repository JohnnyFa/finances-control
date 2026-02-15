import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

class HomeCalculationResult {
  final int totalIncome;
  final int totalExpense;
  final List<ExpenseCategorySummary> summaries;
  final List<RecurringTransaction> recurringForMonth;

  HomeCalculationResult({
    required this.totalIncome,
    required this.totalExpense,
    required this.summaries,
    required this.recurringForMonth,
  });
}
