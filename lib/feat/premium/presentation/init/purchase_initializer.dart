import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source.dart';
import 'package:finances_control/feat/premium/data/datasource/play_billling_data_source.dart';
import 'package:finances_control/feat/premium/data/model/product_ids.dart';
import 'package:finances_control/feat/premium/data/model/purchase_model.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';

class PurchaseInitializer {
  final PlayBillingDataSource billing;
  final LocalPurchaseDataSource local;
  bool _isInitialized = false;

  PurchaseInitializer({
    required this.billing,
    required this.local,
  });

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    final available = await billing.isAvailable();
    if (!available) {
      return;
    }

    billing.initPurchaseListener((purchase) async {
      final model = PurchaseModel.fromPurchaseDetails(purchase);

      if (!model.isActive) return;

      final entitlement = _mapProductToEntitlement(model.productId);

      await _saveEntitlementSafely(entitlement);
    });

    _isInitialized = true;
  }

  Future<void> _saveEntitlementSafely(Entitlement newValue) async {
    final current = await local.getEntitlement() ?? Entitlement.free;

    if (newValue == Entitlement.premium) {
      await local.saveEntitlement(Entitlement.premium);
      return;
    }

    if (newValue == Entitlement.noAds && current != Entitlement.premium) {
      await local.saveEntitlement(Entitlement.noAds);
    }
  }

  Entitlement _mapProductToEntitlement(String productId) {
    if (productId == ProductIds.premiumMonthly) {
      return Entitlement.premium;
    }

    if (productId == ProductIds.removeAds) {
      return Entitlement.noAds;
    }

    return Entitlement.free;
  }
}
