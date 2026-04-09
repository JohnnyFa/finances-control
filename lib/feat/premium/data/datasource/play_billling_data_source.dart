import 'package:in_app_purchase/in_app_purchase.dart';

class BillingUnavailableException implements Exception {
  const BillingUnavailableException();
}

abstract class PlayBillingDataSource {
  Future<List<ProductDetails>> getProducts(Set<String> ids);
  Future<void> buy(String productId);
  Future<List<String>> restore();
  void initPurchaseListener(Function(PurchaseDetails) onPurchase);
}
