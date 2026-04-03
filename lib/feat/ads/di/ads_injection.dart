import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/service/ad_visibility_service.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';

void adsInjection() {
  getIt.registerLazySingleton<AdVisibilityService>(
    () => AdVisibilityService(getIt(), getIt()),
  );

  getIt.registerFactoryParam<AdViewModel, AdPlacement, void>(
    (placement, _) => AdViewModel(
      adVisibilityService: getIt(),
      placement: placement,
    ),
  );
}
