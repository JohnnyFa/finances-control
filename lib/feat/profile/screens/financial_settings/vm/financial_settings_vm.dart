import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';

import 'financial_settings_state.dart';

class FinancialSettingsViewModel extends Cubit<FinancialSettingsState> {
  final UserRepository _userRepository;

  FinancialSettingsViewModel(this._userRepository)
      : super(FinancialSettingsLoading());

  Future<void> load() async {
    try {
      final user = await _userRepository.get();

      emit(
        FinancialSettingsLoaded(
          salary: user.salary,
          amountToSave: user.amountToSaveByMonth ?? 0,
        ),
      );
    } catch (e) {
      emit(FinancialSettingsError(FinancialSettingsErrorType.loadFailed));
    }
  }

  void updateSalary(int salary) {
    final current = state;

    if (current is FinancialSettingsLoaded) {
      emit(current.copyWith(salary: salary));
    }
  }

  void updateSavings(int value) {
    final current = state;

    if (current is FinancialSettingsLoaded) {
      emit(current.copyWith(amountToSave: value));
    }
  }

  Future<void> save() async {
    final current = state;

    if (current is FinancialSettingsLoaded) {
      try {

        if (current.salary <= 0) {
          emit(FinancialSettingsError(FinancialSettingsErrorType.salaryGreaterThanZero));
          return;
        }

        if (current.amountToSave <= 0) {
          emit(FinancialSettingsError(FinancialSettingsErrorType.savingsGreaterThanZero));
          return;
        }

        final user = await _userRepository.get();

        final updatedUser = user.copyWith(
          salary: current.salary,
          amountToSaveByMonth: current.amountToSave,
        );

        await _userRepository.update(updatedUser);

        emit(current);

      } catch (e) {
        emit(FinancialSettingsError(FinancialSettingsErrorType.saveFailed));
      }
    }
  }
}