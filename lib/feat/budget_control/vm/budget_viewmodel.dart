import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/vm/budget_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetViewModel extends Cubit<BudgetState> {
  final BudgetRepository repository;

  BudgetViewModel(this.repository) : super(BudgetInitial());

  Future<void> load(int month, int year) async {
    emit(BudgetLoading());
    try {
      final budgets = await repository.getBudgetsByMonth(month, year);
      emit(BudgetLoaded(budgets: budgets, month: month, year: year));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> addBudget(String categoryId, int month, int year, int limitCents) async {
    try {
      await repository.upsertBudget(categoryId, month, year, limitCents);
      await load(month, year);
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> deleteBudget(String categoryId, int month, int year) async {
    try {
      await repository.deleteBudget(categoryId, month, year);
      await load(month, year);
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}
