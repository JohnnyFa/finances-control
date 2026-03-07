abstract class AccountSettingsState {}
class AccountSettingsLoading extends AccountSettingsState {}

class AccountSettingsLoaded extends AccountSettingsState {
  final String name;
  final String? email;

  AccountSettingsLoaded({
    required this.name,
    this.email,
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

class AccountSettingsError extends AccountSettingsState {
  final String message;

  AccountSettingsError(this.message);
}