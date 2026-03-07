import 'package:flutter/material.dart';

abstract class PreferencesState {}

class PreferencesLoading extends PreferencesState {}

class PreferencesLoaded extends PreferencesState {
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  PreferencesLoaded({
    required this.notificationsEnabled,
    required this.themeMode,
  });

  PreferencesLoaded copyWith({
    bool? notificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return PreferencesLoaded(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class PreferencesError extends PreferencesState {
  final String message;

  PreferencesError(this.message);
}