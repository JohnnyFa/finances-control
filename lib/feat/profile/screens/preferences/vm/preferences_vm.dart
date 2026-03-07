import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'preferences_state.dart';

class PreferencesViewModel extends Cubit<PreferencesState> {
  PreferencesViewModel() : super(PreferencesLoading()) {
    load();
  }

  void load() {
    // Don't overwrite state if already loaded (e.g. when re-entering the page)
    if (state is PreferencesLoaded) return;

    emit(
      PreferencesLoaded(
        notificationsEnabled: true,
        themeMode: ThemeMode.system,
      ),
    );
  }

  void toggleNotifications(bool value) {
    final current = state;

    if (current is PreferencesLoaded) {
      emit(current.copyWith(notificationsEnabled: value));
    }
  }

  void changeTheme(ThemeMode mode) {
    final current = state;

    if (current is PreferencesLoaded) {
      emit(current.copyWith(themeMode: mode));
    }
  }
}