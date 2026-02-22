import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/open_finance/data/dao/bank_connection_dao.dart';
import 'package:finances_control/feat/open_finance/data/dao/bank_transaction_dao.dart';
import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';
import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository_impl.dart';
import 'package:finances_control/feat/open_finance/usecase/connect_bank.dart';
import 'package:finances_control/feat/open_finance/usecase/get_bank_connections.dart';
import 'package:finances_control/feat/open_finance/usecase/sync_bank_payments.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_viewmodel.dart';

void openFinanceInjection() {
  getIt.registerLazySingleton(() => BankConnectionDao(getIt()));
  getIt.registerLazySingleton(() => BankTransactionDao(getIt()));
  getIt.registerLazySingleton<OpenFinanceRepository>(
    () => OpenFinanceRepositoryImpl(getIt(), getIt(), getIt()),
  );

  getIt.registerFactory(() => ConnectBankUseCase(getIt()));
  getIt.registerFactory(() => GetBankConnectionsUseCase(getIt()));
  getIt.registerFactory(() => SyncBankPaymentsUseCase(getIt()));

  getIt.registerFactory(
    () => OpenFinanceViewModel(
      getBankConnectionsUseCase: getIt(),
      connectBankUseCase: getIt(),
      syncBankPaymentsUseCase: getIt(),
    ),
  );
}
