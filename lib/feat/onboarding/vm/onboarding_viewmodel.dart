import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/onboarding/usecase/save_user.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingViewModel extends Cubit<OnboardingState> {
  final SaveUserUseCase saveUserUseCase;

  OnboardingViewModel({required this.saveUserUseCase})
    : super(OnboardingState.initial());

  void nextStep() {
    switch (state.step) {
      case 0:
        if (!state.isNameValid) {
          emit(state.copyWith(validationError: 'Por favor, informe seu nome'));
          return;
        }
        break;

      case 1:
        if (!state.isSalaryValid) {
          emit(state.copyWith(validationError: 'Informe um salário válido'));
          return;
        }
        break;
    }
    emit(state.copyWith(step: state.step + 1, clearValidationError: true));
  }

  void previousStep() {
    if (state.step == 0) return;

    emit(state.copyWith(step: state.step - 1, validationError: null));
  }

  void updateName(String name) {
    final trimmed = name.trim();

    emit(
      state.copyWith(
        name: name,
        isNameValid: trimmed.isNotEmpty,
        validationError: null,
      ),
    );
  }

  void updateSalary(int salaryInCents) {
    emit(
      state.copyWith(
        salaryInCents: salaryInCents,
        isSalaryValid: salaryInCents > 0,
        validationError: null,
      ),
    );
  }

  void updateGoal(int goalInCents) {
    emit(
      state.copyWith(
        goalInCents: goalInCents,
        isGoalValid: goalInCents >= 0,
        validationError: null,
      ),
    );
  }

  Future<void> saveUser() async {
    emit(state.copyWith(status: OnboardingStatus.loading));

    final user = User(
      name: state.name.trim(),
      salary: state.salaryInCents,
      amountToSaveByMonth: state.goalInCents,
    );

    await saveUserUseCase(user);

    emit(state.copyWith(status: OnboardingStatus.success));
  }
}
