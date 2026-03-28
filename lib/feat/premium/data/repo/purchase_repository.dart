import 'package:finances_control/feat/premium/domain/entitlement.dart';

abstract class PurchaseRepository {
  Future<Entitlement> getEntitlement();
  Future<void> buyRemoveAds();
  Future<Entitlement> restorePurchases();
}