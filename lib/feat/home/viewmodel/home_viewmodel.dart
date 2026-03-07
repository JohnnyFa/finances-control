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

  final int _currentYear = DateTime.now().year;
  final int _currentMonth = DateTime.now().month;

  HomeViewModel(
      this.getTransactions,
      this.getGlobalEconomy,
      this.getRecurring,
      this.getUser,
      this.calculator,
      ) : super(HomeInitial());

  Future<void> load(int year, int month) async {

    emit(HomeLoading(year: year, month: month));

    final start = DateTime.now();

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

      final elapsed = DateTime.now().difference(start);
      if (elapsed < const Duration(milliseconds: 300)) {
        await Future.delayed(const Duration(milliseconds: 300) - elapsed);
      }

      emit(
        HomeLoaded(
          year: year,
          month: month,
          totalIncome: result.totalIncome,
          totalExpense: result.totalExpense,
          categories: result.summaries,
          globalEconomy: globalEconomy,
          recurring: result.recurringForMonth,
          user: user,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> reload() => load(_currentYear, _currentMonth);
}