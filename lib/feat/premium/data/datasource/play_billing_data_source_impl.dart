import 'dart:async';

import 'package:finances_control/feat/premium/data/datasource/play_billling_data_source.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PlayBillingDataSourceImpl implements PlayBillingDataSource {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  Future<bool> isAvailable() {
    return _iap.isAvailable();
  }

  @override
  Future<List<ProductDetails>> getProducts(Set<String> ids) async {
    final available = await isAvailable();
    if (!available) {
      throw const BillingUnavailableException();
    }

    final response = await _iap.queryProductDetails(ids);

    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    return response.productDetails;
  }

  @override
  Future<void> buy(String productId) async {
    final products = await getProducts({productId});

    if (products.isEmpty) {
      throw Exception('Product not found');
    }

    final product = products.first;

    final purchaseParam = PurchaseParam(productDetails: product);

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<List<String>> restore() async {
    final available = await isAvailable();
    if (!available) {
      throw const BillingUnavailableException();
    }

    final completer = Completer<List<String>>();
    final purchasedIds = <String>{};

    late StreamSubscription sub;

    sub = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.restored ||
            purchase.status == PurchaseStatus.purchased) {
          purchasedIds.add(purchase.productID);

          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        }
      }

      if (purchases.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 2));
        await sub.cancel();

        if (!completer.isCompleted) {
          completer.complete(purchasedIds.toList(growable: false));
        }
      }
    });

    await _iap.restorePurchases();

    try {
      return await completer.future.timeout(const Duration(seconds: 8));
    } on TimeoutException {
      await sub.cancel();
      return purchasedIds.toList(growable: false);
    }
  }

  @override
  void initPurchaseListener(Function(PurchaseDetails) onPurchase) {
    _subscription?.cancel();

    _subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          onPurchase(purchase);

          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        }

        if (purchase.status == PurchaseStatus.error) {
          // you can log here
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
