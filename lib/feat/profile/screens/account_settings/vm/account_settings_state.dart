abstract class AccountSettingsState {}

class AccountSettingsLoading extends AccountSettingsState {}

class AccountSettingsLoaded extends AccountSettingsState {
  final String? name;
  final String? email;
  final String? nameError;

  AccountSettingsLoaded({this.name, this.email, this.nameError});

  AccountSettingsLoaded copyWith({
    String? name,
    String? email,
    String? nameError,
  }) {
    return AccountSettingsLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      nameError: nameError,
    );
  }
}

class AccountSettingsError extends AccountSettingsState {
  final String message;

  AccountSettingsError(this.message);
}
