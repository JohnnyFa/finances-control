import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/home/usecase/get_expenses_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';

void homeInjection() {
  getIt.registerFactory(() => GetExpensesByMonthUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsByMonthUseCase(getIt()));
  getIt.registerFactory(() => HomeViewModel(getIt()));
}
