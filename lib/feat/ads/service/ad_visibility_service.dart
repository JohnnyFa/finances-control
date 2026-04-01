import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/feat/ads/domain/ads_config.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';

class AdVisibilityService {
  final GetUserEntitlementUseCase getEntitlement;
  final AppRemoteConfig remoteConfig;

  AdVisibilityService(this.getEntitlement, this.remoteConfig);

  Future<bool> shouldShowAd(AdPlacement placement) async {
    final entitlement = await getEntitlement();

    if (entitlement != Entitlement.free) return false;

    final config = AdsConfig.fromJson(
      remoteConfig.getJson(RemoteConfigKey.allowedAds),
    );

    switch (placement) {
      case AdPlacement.home:
        return config.home;

      case AdPlacement.transactions:
        return config.transactions;

      case AdPlacement.budgetCategory:
        return config.budgetCategory;

      case AdPlacement.newTransaction:
        return config.newTransaction;
    }
  }
}