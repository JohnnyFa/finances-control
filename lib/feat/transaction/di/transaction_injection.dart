import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository_impl.dart';
import 'package:finances_control/feat/transaction/data/recurring/dao/recurring_transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/transaction/dao/transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository_impl.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';

void transactionInjection() {
  getIt.registerLazySingleton<TransactionDao>(() => TransactionDao(getIt()));
  getIt.registerLazySingleton<RecurringTransactionDao>(
    () => RecurringTransactionDao(getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<RecurringTransactionRepository>(
    () => RecurringTransactionRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt()));
  getIt.registerFactory(() => AddRecurringTransactionUseCase(getIt()));
  getIt.registerFactory(() => UpdateTransactionUseCase(getIt()));
  getIt.registerFactory(() => DeleteTransactionUseCase(getIt()));

  getIt.registerFactory(
    () => TransactionViewModel(
      addUseCase: getIt(),
      getUseCase: getIt(),
      addRecurringUseCase: getIt(),
      updateUseCase: getIt(),
      deleteUseCase: getIt(),
    ),
  );
}
