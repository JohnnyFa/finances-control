import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source.dart';
import 'package:finances_control/feat/premium/data/datasource/play_billling_data_source.dart';
import 'package:finances_control/feat/premium/data/model/product_ids.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  PurchaseRepositoryImpl(this.local, this.billing);

  final LocalPurchaseDataSource local;
  final PlayBillingDataSource billing;

  @override
  Future<Entitlement> getEntitlement() async {
    final localValue = await local.getEntitlement();
    return localValue ?? Entitlement.free;
  }

  @override
  Future<void> buyRemoveAds() async {
    await billing.buy(ProductIds.removeAds);
  }

  @override
  Future<Entitlement> restorePurchases() async {
    final purchases = await billing.restore();

    Entitlement entitlement = Entitlement.free;

    if (purchases.contains(ProductIds.premiumMonthly)) {
      entitlement = Entitlement.premium;
    } else if (purchases.contains(ProductIds.removeAds)) {
      entitlement = Entitlement.noAds;
    }

    await local.saveEntitlement(entitlement);

    return entitlement;
  }
}