import 'package:finances_control/core/db/database_helper.dart';
import 'package:finances_control/feat/home/di/home_injection.dart';
import 'package:finances_control/feat/open_finance/di/open_finance_injection.dart';
import 'package:finances_control/feat/onboarding/di/onboarding_injection.dart';
import 'package:finances_control/feat/start/di/start_injection.dart';
import 'package:finances_control/feat/transaction/di/transaction_injection.dart';
import 'package:finances_control/l10n_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqlite_api.dart';

final getIt = GetIt.instance;

void setupLocator() async {
  getIt.registerLazySingleton(AppStrings.new);
  getIt.registerSingletonAsync<Database>(
    () async => await DatabaseHelper.instance.database,
  );
  await getIt.isReady<Database>();
  startInjection();
  homeInjection();
  transactionInjection();
  onboardingInjection();
  openFinanceInjection();
}
