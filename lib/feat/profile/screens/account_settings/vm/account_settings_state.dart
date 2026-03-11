abstract class AccountSettingsState {}

class AccountSettingsLoading extends AccountSettingsState {}

class AccountSettingsSaving extends AccountSettingsState {}

class AccountSettingsLoaded extends AccountSettingsState {
  final String? name;
  final String? email;

  AccountSettingsLoaded({
    required this.name,
    required this.email,
  });

  AccountSettingsLoaded copyWith({
    String? name,
    String? email,
  }) {
    return AccountSettingsLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

class AccountSettingsSuccess extends AccountSettingsState {}

class AccountSettingsError extends AccountSettingsState {
  final String message;

  AccountSettingsError(this.message);
}