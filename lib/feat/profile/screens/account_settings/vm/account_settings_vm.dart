import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'account_settings_state.dart';

class AccountSettingsViewModel extends Cubit<AccountSettingsState> {
  final UserRepository _userRepository;

  AccountSettingsViewModel(this._userRepository)
      : super(AccountSettingsLoading());

  Future<void> load() async {
    try {
      final user = await _userRepository.get();

      emit(
        AccountSettingsLoaded(
          name: user.name.isEmpty ? null : user.name,
          email: user.email,
        ),
      );
    } catch (_) {
      emit(AccountSettingsLoaded(name: null, email: null));
    }
  }

  Future<void> save({
    required String name,
    required String email,
  }) async {
    final current = state;

    if (current is! AccountSettingsLoaded) return;

    /// VALIDATION
    if (name.trim().isEmpty) {
      emit(AccountSettingsError("Name cannot be empty"));
      emit(current);
      return;
    }

    try {
      final user = await _userRepository.get();

      final updatedUser = user.copyWith(
        name: name.trim(),
        email: email.trim().isEmpty ? null : email.trim(),
      );

      await _userRepository.update(updatedUser);

      emit(
        current.copyWith(
          name: updatedUser.name,
          email: updatedUser.email,
        ),
      );
    } catch (_) {
      emit(AccountSettingsError("Failed to save account settings"));
    }
  }
}