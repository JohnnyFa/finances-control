import 'dart:async';

import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartViewModel extends Cubit<AppStartState> {
  final HasUserUseCase hasUserUseCase;
  final RestorePurchasesUseCase restorePurchasesUseCase;

  AppStartViewModel(
    this.hasUserUseCase,
    this.restorePurchasesUseCase,
  ) : super(const AppStartState.loading());

  Future<void> check() async {
    final hasUser = await hasUserUseCase();

    if (hasUser) {
      await _tryRestorePurchases();
      emit(const AppStartState.home());
      return;
    }

    unawaited(_tryRestorePurchases());
    emit(const AppStartState.onboarding());
  }

  Future<void> _tryRestorePurchases() async {
    try {
      await restorePurchasesUseCase();
    } catch (_) {
      // fallback to local cached entitlement (loaded later by PurchaseViewModel)
    }
  }
}
