import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/onboarding/usecase/save_user.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingViewModel extends Cubit<OnboardingState> {
  final SaveUserUseCase saveUserUseCase;

  OnboardingViewModel({required this.saveUserUseCase})
      : super(OnboardingState.initial());

  void nextStep() {
    emit(state.copyWith(step: state.step + 1));
  }

  void previousStep() {
    emit(state.copyWith(step: state.step - 1));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateSalary(int salaryInCents) {
    emit(state.copyWith(salaryInCents: salaryInCents));
  }

  void updateGoal(int goalInCents) {
    emit(state.copyWith(goalInCents: goalInCents));
  }

  Future<void> saveUser(User user) async {
    try {
      emit(state.copyWith(status: OnboardingStatus.loading));

      await saveUserUseCase(user);

      emit(state.copyWith(status: OnboardingStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.error,
        error: e.toString(),
      ));
    }
  }
}