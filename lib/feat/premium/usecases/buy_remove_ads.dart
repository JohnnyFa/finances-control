import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';

class BuyRemoveAdsUseCase {
  final PurchaseRepository repository;

  BuyRemoveAdsUseCase(this.repository);

  Future<void> call() async {
    await repository.buyRemoveAds();
  }
}