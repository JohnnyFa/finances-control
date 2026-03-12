import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/transaction/data/recurring/dao/recurring_transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository_impl.dart';
import 'package:finances_control/feat/transaction/data/transaction/dao/transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository_impl.dart';
import 'package:finances_control/feat/transaction/services/csv_file_picker_service.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/import_csv_transactions.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
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

  getIt.registerLazySingleton(() => CsvFilePickerService());
  getIt.registerLazySingleton(() => InterstitialAdService());
  getIt.registerLazySingleton(() => CsvParser());

  getIt.registerFactory(() => AddTransactionUseCase(getIt()));
  getIt.registerFactory(() => GetTransactionsUseCase(getIt(), getIt()));
  getIt.registerFactory(() => AddRecurringTransactionUseCase(getIt()));
  getIt.registerFactory(() => UpdateTransactionUseCase(getIt()));
  getIt.registerFactory(() => DeleteTransactionUseCase(getIt()));
  getIt.registerFactory(() => DeleteRecurringTransactionUseCase(getIt()));
  getIt.registerFactory(
    () => ImportCsvTransactionsUseCase(
      filePickerService: getIt(),
      csvParser: getIt(),
      repository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => TransactionViewModel(
      addUseCase: getIt(),
      getUseCase: getIt(),
      addRecurringUseCase: getIt(),
      deleteRecurringUseCase: getIt(),
      updateUseCase: getIt(),
      deleteUseCase: getIt(),
      importCsvUseCase: getIt(),
      interstitialService: getIt(),
    ),
  );
}
