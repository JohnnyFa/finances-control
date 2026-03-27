import 'package:finances_control/core/db/database_helper.dart';
import 'package:finances_control/core/services/image_service.dart';
import 'package:finances_control/feat/budget_control/di/budget_injection.dart';
import 'package:finances_control/feat/ebooks/di/ebooks_injection.dart';
import 'package:finances_control/feat/home/di/home_injection.dart';
import 'package:finances_control/feat/onboarding/di/onboarding_injection.dart';
import 'package:finances_control/feat/profile/di/profile_injection.dart';
import 'package:finances_control/feat/start/di/start_injection.dart';
import 'package:finances_control/feat/transaction/di/transaction_injection.dart';
import 'package:finances_control/l10n_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqlite_api.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(AppStrings.new);
  getIt.registerSingletonAsync<Database>(
    () async => await DatabaseHelper.instance.database,
  );
  getIt.registerLazySingleton(() => ImageService());
  await getIt.isReady<Database>();
  startInjection();
  onboardingInjection();
  homeInjection();
  transactionInjection();
  profileInjection();
  budgetInjection();
  ebooksInjection();
}
