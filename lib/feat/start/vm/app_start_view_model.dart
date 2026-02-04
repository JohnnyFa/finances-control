import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartViewModel extends Cubit<AppStartState> {
  final HasUserUseCase hasUserUseCase;

  AppStartViewModel(this.hasUserUseCase) : super(const AppStartState.loading());

  Future<void> check() async {
    final hasUser = await hasUserUseCase();

    emit(
      hasUser ? const AppStartState.home() : const AppStartState.onboarding(),
    );
  }
}
