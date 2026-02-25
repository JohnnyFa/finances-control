import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User user;
  final String? error;

  const ProfileState({
    required this.status,
    required this.user,
    this.error,
  });

  factory ProfileState.initial() {
    return ProfileState(
      status: ProfileStatus.initial,
      user: User.empty(),
    );
  }

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}
