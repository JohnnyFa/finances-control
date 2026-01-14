import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/usecase/get_expenses_by_month.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final GetExpensesByMonthUseCase getExpenses;

  HomeViewModel(this.getExpenses) : super(HomeState.initial());

  Future<void> load(int year, int month) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final transactions = await getExpenses(year, month);

      if (transactions.isEmpty) {
        emit(state.copyWith(status: HomeStatus.success, categories: []));
        return;
      }

      final Map<Category, BigDecimal> totals = {};

      for (final tx in transactions) {
        totals.update(
          tx.category,
          (value) => value + tx.amount,
          ifAbsent: () => tx.amount,
        );
      }

      final BigDecimal grandTotal = totals.values.fold(
        BigDecimal.zero,
        (a, b) => a + b,
      );

      final summaries = totals.entries.map((entry) {
        final double percentage = grandTotal == BigDecimal.zero
            ? 0
            : (entry.value.toDouble() / grandTotal.toDouble()) * 100;

        return ExpenseCategorySummary(
          category: entry.key,
          total: entry.value,
          percentage: percentage,
        );
      }).toList()..sort((a, b) => b.total.compareTo(a.total));

      emit(state.copyWith(status: HomeStatus.success, categories: summaries));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, error: e.toString()));
    }
  }

  Future<void> reload() async {
    await load(
      state.year ?? DateTime.now().year,
      state.month ?? DateTime.now().month,
    );
  }
}
