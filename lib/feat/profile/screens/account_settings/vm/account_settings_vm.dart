import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_settings_state.dart';

class AccountSettingsViewModel extends Cubit<AccountSettingsState> {
  AccountSettingsViewModel() : super(AccountSettingsLoading());

  void load() {
    /// depois isso virá do repository
    emit(
      AccountSettingsLoaded(
        name: "Johnny",
        email: "johnny@email.com",
      ),
    );
  }

  void updateName(String name) {
    final current = state;

    if (current is AccountSettingsLoaded) {
      emit(current.copyWith(name: name));
    }
  }

  void updateEmail(String email) {
    final current = state;

    if (current is AccountSettingsLoaded) {
      emit(current.copyWith(email: email));
    }
  }
}