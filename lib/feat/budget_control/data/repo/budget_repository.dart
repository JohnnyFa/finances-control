import 'package:finances_control/feat/budget_control/domain/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgetsByMonth(int month, int year);
  Future<void> upsertBudget(String categoryId, int month, int year, int limitCents);
  Future<void> deleteBudget(String categoryId, int month, int year);
}
