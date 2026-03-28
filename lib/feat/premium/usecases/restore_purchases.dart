import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';

class RestorePurchasesUseCase {
  final PurchaseRepository repository;

  RestorePurchasesUseCase(this.repository);

  Future<Entitlement> call() async {
    return repository.restorePurchases();
  }
}