import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:finances_control/core/db/database_helper.dart';
import 'package:finances_control/core/crashlytics/crashlytics_service.dart';
import 'package:finances_control/core/crashlytics/crashlytics_service_impl.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config_impl.dart';
import 'package:finances_control/core/services/image_service.dart';
import 'package:finances_control/feat/ads/di/ads_injection.dart';
import 'package:finances_control/feat/budget_control/di/budget_injection.dart';
import 'package:finances_control/feat/ebooks/di/ebooks_injection.dart';
import 'package:finances_control/feat/home/di/home_injection.dart';
import 'package:finances_control/feat/onboarding/di/onboarding_injection.dart';
import 'package:finances_control/feat/premium/di/premium_injection.dart';
import 'package:finances_control/feat/profile/di/profile_injection.dart';
import 'package:finances_control/feat/start/di/start_injection.dart';
import 'package:finances_control/feat/transaction/di/transaction_injection.dart';
import 'package:finances_control/l10n_helper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqlite_api.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(AppStrings.new);
  getIt.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );
  getIt.registerLazySingleton<CrashlyticsService>(
    () => CrashlyticsServiceImpl(getIt<FirebaseCrashlytics>()),
  );
  getIt.registerSingletonAsync<Database>(
    () async => await DatabaseHelper.instance.database,
  );
  getIt.registerLazySingleton(() => ImageService());
  await remoteConfigInjection();
  await getIt.isReady<Database>();
  startInjection();
  onboardingInjection();
  homeInjection();
  transactionInjection();
  profileInjection();
  budgetInjection();
  ebooksInjection();
  await premiumInjection();
  adsInjection();
}

Future<void> remoteConfigInjection() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ),
  );

  await remoteConfig.fetchAndActivate();

  getIt.registerLazySingleton<FirebaseRemoteConfig>(() => remoteConfig);

  getIt.registerLazySingleton<AppRemoteConfig>(
        () => FirebaseRemoteConfigImpl(remoteConfig),
  );
}
