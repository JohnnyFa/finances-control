import 'dart:async';

import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/usecases/buy_remove_ads.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseViewModel extends Cubit<PurchaseState> {
  final BuyRemoveAdsUseCase buyRemoveAds;
  final GetUserEntitlementUseCase getEntitlement;
  final RestorePurchasesUseCase restorePurchases;
  final Duration _purchaseSyncInterval;
  final int _purchaseSyncAttempts;

  PurchaseViewModel(
    this.buyRemoveAds,
    this.getEntitlement,
    this.restorePurchases,
    {
    Duration purchaseSyncInterval = const Duration(milliseconds: 300),
    int purchaseSyncAttempts = 10,
  })  : _purchaseSyncInterval = purchaseSyncInterval,
        _purchaseSyncAttempts = purchaseSyncAttempts,
        super(PurchaseInitial());

  Future<void> load() async {
    emit(PurchaseLoading());

    try {
      await _emitCurrentEntitlement();
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> removeAds() async {
    emit(PurchaseLoading());

    try {
      await buyRemoveAds();
      await _emitCurrentEntitlementAfterPurchase();
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> restore() async {
    emit(PurchaseLoading());

    try {
      final entitlement = await restorePurchases();
      emit(PurchaseSuccess(entitlement));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> _emitCurrentEntitlement() async {
    final entitlement = await getEntitlement();
    emit(PurchaseSuccess(entitlement));
  }

  Future<void> _emitCurrentEntitlementAfterPurchase() async {
    var entitlement = await getEntitlement();

    for (var i = 0; i < _purchaseSyncAttempts; i++) {
      if (entitlement != Entitlement.free) {
        emit(PurchaseSuccess(entitlement));
        return;
      }

      await Future.delayed(_purchaseSyncInterval);
      entitlement = await getEntitlement();
    }

    emit(PurchaseSuccess(entitlement));
  }
}
