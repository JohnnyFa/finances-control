import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';

class GetUserEntitlementUseCase {
  final PurchaseRepository repo;

  GetUserEntitlementUseCase(this.repo);

  Future<Entitlement> call() => repo.getEntitlement();
}