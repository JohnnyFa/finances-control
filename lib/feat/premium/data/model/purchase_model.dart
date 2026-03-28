import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseModel {
  final String productId;
  final bool isActive;

  const PurchaseModel({
    required this.productId,
    required this.isActive,
  });

  factory PurchaseModel.fromPurchaseDetails(PurchaseDetails purchase) {
    return PurchaseModel(
      productId: purchase.productID,
      isActive: purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored,
    );
  }
}