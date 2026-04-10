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

    try {
      await restorePurchasesUseCase();
    } catch (_) {
      // fallback to local cached entitlement (loaded later by PurchaseViewModel)
    }

    emit(
      hasUser ? const AppStartState.home() : const AppStartState.onboarding(),
    );
  }
}
