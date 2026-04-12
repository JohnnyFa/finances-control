import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartViewModel extends Cubit<AppStartState> {
  final HasUserUseCase hasUserUseCase;
  final AnalyticsService analyticsService;

  AppStartViewModel(
    this.hasUserUseCase,
    this.analyticsService,
  ) : super(const AppStartState.loading());

  Future<void> check() async {
    final hasUser = await hasUserUseCase();

    if (hasUser) {
      try {
        await analyticsService.trackOnboardingSkipped();
      } catch (_) {}
      emit(const AppStartState.home());
      return;
    }

    emit(const AppStartState.onboarding());
  }
}
