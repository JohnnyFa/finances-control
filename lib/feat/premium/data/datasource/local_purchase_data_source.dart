import 'package:finances_control/feat/premium/domain/entitlement.dart';

abstract class LocalPurchaseDataSource {
  Future<void> saveEntitlement(Entitlement entitlement);
  Future<Entitlement?> getEntitlement();
}