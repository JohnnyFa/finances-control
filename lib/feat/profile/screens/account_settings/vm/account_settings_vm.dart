import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    required AppLocalizations strings,
  }) async {
    final current = state;

    if (current is! AccountSettingsLoaded) return;

    if (name.trim().isEmpty) {
      emit(AccountSettingsError(strings.name_cannot_be_empty));
      emit(current);
      return;
    }

    emit(AccountSettingsSaving());

    try {
      final user = await _userRepository.get();

      final updatedUser = user.copyWith(
        name: name.trim(),
        email: email.trim().isEmpty ? null : email.trim(),
      );

      await _userRepository.update(updatedUser);
      emit(current);
      emit(AccountSettingsSuccess());
    } catch (_) {
      emit(AccountSettingsError(strings.failed_to_save_account_settings));
      emit(current);
    }
  }
}