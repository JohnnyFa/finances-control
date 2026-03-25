import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/data/repo/budget_repository_impl.dart';
import 'package:finances_control/feat/budget_control/vm/budget_viewmodel.dart';

void budgetInjection() {
  getIt.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => BudgetViewModel(getIt(), getIt<InterstitialAdService>()));
}
