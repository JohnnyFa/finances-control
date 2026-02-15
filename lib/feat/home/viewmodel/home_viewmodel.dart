import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/home/usecase/get_active_recurring_transaction.dart';
import 'package:finances_control/feat/home/usecase/get_global_economy.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final GetTransactionsByMonthUseCase getTransactions;
  final GetGlobalEconomyUseCase getGlobalEconomy;
  final GetActiveRecurringTransactionsUseCase getRecurring;
  final GetUserUseCase getUser;
  final HomeCalculator calculator;

  HomeViewModel(
      this.getTransactions,
      this.getGlobalEconomy,
      this.getRecurring,
      this.getUser,
      this.calculator,
      ) : super(HomeState.initial());

  Future<void> load(int year, int month) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
      year: year,
      month: month,
    ));

    try {
      final transactions = await getTransactions(year, month);
      final globalEconomy = await getGlobalEconomy();
      final recurring = await getRecurring();
      final user = await getUser();

      final result = calculator.calculate(
        transactions: transactions,
        recurring: recurring,
        year: year,
        month: month,
      );

      emit(
        state.copyWith(
          status: HomeStatus.success,
          totalIncome: result.totalIncome,
          totalExpense: result.totalExpense,
          categories: result.summaries,
          globalEconomy: globalEconomy,
          recurring: result.recurringForMonth,
          user: user,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> reload() => load(state.year, state.month);
}
