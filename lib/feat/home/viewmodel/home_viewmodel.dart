import 'dart:developer';

import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/usecase/get_active_recurring_transaction.dart';
import 'package:finances_control/feat/home/usecase/get_global_economy.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction_rules.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final GetTransactionsByMonthUseCase getTransactions;
  final GetGlobalEconomyUseCase getGlobalEconomy;
  final GetActiveRecurringTransactionsUseCase getRecurring;
  final GetUserUseCase getUser;

  HomeViewModel(this.getTransactions, this.getGlobalEconomy, this.getRecurring, this.getUser)
    : super(HomeState.initial());

  Future<void> load(int year, int month) async {
    log('HomeViewModel - load called');
    emit(_loadingState(year, month));

    try {
      final transactions = await _fetchTransactions(year, month);
      final globalEconomy = await _fetchGlobalEconomy();
      final recurring = await _fetchRecurringTransactions();
      final user = await _fetchUser();

      final recurringTransactions = _materializeRecurring(
        recurring,
        year,
        month,
      );

      final allTransactions = [...transactions, ...recurringTransactions];

      final totals = _calculateTotals(allTransactions);

      final summaries = _buildExpenseSummaries(
        totals.expenseTotals,
        totals.totalExpense,
      );

      final recurringForMonth = _filterRecurringForMonth(
        recurring,
        year,
        month,
      );

      emit(
        _successState(
          income: totals.totalIncome,
          expense: totals.totalExpense,
          categories: summaries,
          globalEconomy: globalEconomy,
          recurring: recurringForMonth,
          user: user,
        ),
      );
    } catch (e) {
      emit(_errorState(e));
    }
  }

  HomeState _loadingState(int year, int month) {
    return state.copyWith(status: HomeStatus.loading, year: year, month: month, user: state.user);
  }

  HomeState _successState({
    required int income,
    required int expense,
    required List<ExpenseCategorySummary> categories,
    required int globalEconomy,
    required List<RecurringTransaction> recurring,
    required User user,
  }) {
    return state.copyWith(
      status: HomeStatus.success,
      totalIncome: income,
      totalExpense: expense,
      categories: categories,
      globalEconomy: globalEconomy,
      recurring: recurring,
      user: user,
    );
  }

  HomeState _errorState(Object error) {
    return state.copyWith(status: HomeStatus.error, error: error.toString(), user: state.user);
  }

  Future<List<Transaction>> _fetchTransactions(int year, int month) {
    return getTransactions(year, month);
  }

  Future<List<RecurringTransaction>> _fetchRecurringTransactions() {
    return getRecurring();
  }

  Future<int> _fetchGlobalEconomy() {
    return getGlobalEconomy();
  }

  Future<User> _fetchUser() {
    return getUser();
  }

  _TotalsResult _calculateTotals(List<Transaction> transactions) {
    int income = 0;
    int expense = 0;
    final Map<Category, int> expenseTotals = {};

    for (final tx in transactions) {
      final amountInCents = tx.amount;

      if (tx.type == TransactionType.income) {
        income += amountInCents;
      } else {
        expense += amountInCents;

        expenseTotals.update(
          tx.category,
          (value) => value + amountInCents,
          ifAbsent: () => amountInCents,
        );
      }
    }

    return _TotalsResult(
      totalIncome: income,
      totalExpense: expense,
      expenseTotals: expenseTotals,
    );
  }

  List<ExpenseCategorySummary> _buildExpenseSummaries(
    Map<Category, int> expenseTotals,
    int totalExpense,
  ) {
    return expenseTotals.entries.map((e) {
      final percentage = totalExpense == 0
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

  Future<void> reload() => load(state.year, state.month);
}

class _TotalsResult {
  final int totalIncome;
  final int totalExpense;
  final Map<Category, int> expenseTotals;

  _TotalsResult({
    required this.totalIncome,
    required this.totalExpense,
    required this.expenseTotals,
  });
}
