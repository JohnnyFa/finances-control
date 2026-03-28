import 'package:finances_control/feat/premium/data/model/product_ids.dart';
import 'package:finances_control/feat/premium/data/model/purchase_model.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';

class EntitlementMapper {
  static Entitlement map(List<PurchaseModel> purchases) {
    final activeProducts = purchases
        .where((p) => p.isActive)
        .map((p) => p.productId)
        .toSet();

    if (activeProducts.contains(ProductIds.premiumMonthly)) {
      return Entitlement.premium;
    }

    if (activeProducts.contains(ProductIds.removeAds)) {
      return Entitlement.noAds;
    }

    return Entitlement.free;
  }
}