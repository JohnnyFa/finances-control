import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/transaction/data/repo/transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/local/transaction_local_repository.dart';
import 'package:finances_control/feat/transaction/domain/transaction_repository.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';

void transactionInjection() {
  getIt.registerLazySingleton<TransactionDao>(() => TransactionDao(getIt()));
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionLocalRepository(getIt()),
  );
  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt()));

  getIt.registerFactory(
    () => TransactionViewModel(addUseCase: getIt(), getUseCase: getIt()),
  );
}
