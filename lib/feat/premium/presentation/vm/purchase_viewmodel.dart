import 'dart:async';

import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/presentation/init/purchase_initializer.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/usecases/buy_remove_ads.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseViewModel extends Cubit<PurchaseState> {
  final BuyRemoveAdsUseCase buyRemoveAds;
  final GetUserEntitlementUseCase getEntitlement;
  final RestorePurchasesUseCase restorePurchases;
  final PurchaseInitializer purchaseInitializer;
  final Duration _purchaseSyncInterval;
  final int _purchaseSyncAttempts;

  PurchaseViewModel(
    this.buyRemoveAds,
    this.getEntitlement,
    this.restorePurchases,
    this.purchaseInitializer, {
    Duration purchaseSyncInterval = const Duration(milliseconds: 300),
    int purchaseSyncAttempts = 10,
  })  : _purchaseSyncInterval = purchaseSyncInterval,
        _purchaseSyncAttempts = purchaseSyncAttempts,
        super(PurchaseInitial());

  Future<void> load() async {
    _emitIfOpen(PurchaseLoading());

    try {
      await purchaseInitializer.init();
      await _emitCurrentEntitlement();
    } catch (e) {
      _emitIfOpen(PurchaseError(e.toString()));
    }
  }

  Future<void> removeAds() async {
    _emitIfOpen(PurchaseLoading());

    try {
      await purchaseInitializer.init();
      await buyRemoveAds();
      await _emitCurrentEntitlementAfterPurchase();
    } catch (e) {
      _emitIfOpen(PurchaseError(e.toString()));
    }
  }

  Future<void> restore() async {
    _emitIfOpen(PurchaseLoading());

    try {
      await purchaseInitializer.init();
      final entitlement = await restorePurchases();
      _emitIfOpen(PurchaseSuccess(entitlement));
    } catch (e) {
      _emitIfOpen(PurchaseError(e.toString()));
    }
  }

  Future<void> _emitCurrentEntitlement() async {
    final entitlement = await getEntitlement();
    _emitIfOpen(PurchaseSuccess(entitlement));
  }

  Future<void> _emitCurrentEntitlementAfterPurchase() async {
    if (isClosed) return;
    var entitlement = await getEntitlement();
    if (isClosed) return;

    for (var i = 0; i < _purchaseSyncAttempts; i++) {
      if (isClosed) return;
      if (entitlement != Entitlement.free) {
        _emitIfOpen(PurchaseSuccess(entitlement));
        return;
      }

      await Future.delayed(_purchaseSyncInterval);
      if (isClosed) return;
      entitlement = await getEntitlement();
    }

    _emitIfOpen(PurchaseSuccess(entitlement));
  }

  void _emitIfOpen(PurchaseState state) {
    if (isClosed) return;
    emit(state);
  }
}
