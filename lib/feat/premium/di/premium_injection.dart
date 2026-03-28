import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source.dart';
import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source_impl.dart';
import 'package:finances_control/feat/premium/data/datasource/play_billling_data_source.dart';
import 'package:finances_control/feat/premium/data/datasource/play_billing_data_source_impl.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository_impl.dart';
import 'package:finances_control/feat/premium/presentation/init/purchase_initializer.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:finances_control/feat/premium/usecases/buy_remove_ads.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';

Future<void> premiumInjection() async {
  getIt.registerLazySingleton<PurchaseInitializer>(
        () => PurchaseInitializer(
      billing: getIt(),
      local: getIt(),
    ),
  );

  getIt.registerLazySingleton<LocalPurchaseDataSource>(
    () => LocalPurchaseDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<PlayBillingDataSource>(
    () => PlayBillingDataSourceImpl(),
  );

  getIt.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<BuyRemoveAdsUseCase>(
    () => BuyRemoveAdsUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetUserEntitlementUseCase>(
    () => GetUserEntitlementUseCase(getIt()),
  );

  getIt.registerLazySingleton<RestorePurchasesUseCase>(
    () => RestorePurchasesUseCase(getIt()),
  );

  getIt.registerFactory(
    () => PurchaseViewModel(
      getIt(),
      getIt(),
      getIt(),
    ),
  );
}
