import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final GetTransactionsByMonthUseCase getTransactions;

  HomeViewModel(this.getTransactions) : super(HomeState.initial());

  Future<void> load(int year, int month) async {
    emit(_loadingState(year, month));

    try {
      final transactions = await _fetchTransactions(year, month);

      final totals = _calculateTotals(transactions);

      final summaries = _buildExpenseSummaries(
        totals.expenseTotals,
        totals.totalExpense,
      );

      emit(
        _successState(
          income: totals.totalIncome,
          expense: totals.totalExpense,
          categories: summaries,
        ),
      );
    } catch (e) {
      emit(_errorState(e));
    }
  }

  HomeState _loadingState(int year, int month) {
    return state.copyWith(status: HomeStatus.loading, year: year, month: month);
  }

  HomeState _successState({
    required int income,
    required int expense,
    required List<ExpenseCategorySummary> categories,
  }) {
    return state.copyWith(
      status: HomeStatus.success,
      totalIncome: income,
      totalExpense: expense,
      categories: categories,
    );
  }

  HomeState _errorState(Object error) {
    return state.copyWith(status: HomeStatus.error, error: error.toString());
  }

  Future<List<Transaction>> _fetchTransactions(int year, int month) {
    return getTransactions(year, month);
  }

  _TotalsResult _calculateTotals(List<Transaction> transactions) {
    int income = 0;
    int expense = 0;
    final Map<Category, int> expenseTotals = {};

    for (final tx in transactions) {
      final amountInCents = bigDecimalToCents(tx.amount);

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
