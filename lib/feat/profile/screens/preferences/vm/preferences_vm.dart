import 'package:finances_control/core/shared_preferences/app_preferences.dart';
import 'package:finances_control/core/shared_preferences/preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'preferences_state.dart';

class PreferencesViewModel extends Cubit<PreferencesState> {
  PreferencesViewModel() : super(PreferencesLoading()) {
    load();
  }

  void load() {
    final savedTheme = AppPreferences.I.getString(
      PreferencesKeys.themeMode,
    );

    ThemeMode themeMode = ThemeMode.system;

    if (savedTheme != null) {
      themeMode = ThemeMode.values.byName(savedTheme);
    }

    emit(
      PreferencesLoaded(
        notificationsEnabled: true,
        themeMode: themeMode,
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

      AppPreferences.I.setString(
        PreferencesKeys.themeMode,
        mode.name,
      );

      emit(current.copyWith(themeMode: mode));
    }
  }
}