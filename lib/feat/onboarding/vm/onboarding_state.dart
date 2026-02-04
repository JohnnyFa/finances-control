
import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, loading, success, error }

class OnboardingState extends Equatable {
  final int step;
  final String name;
  final int salaryInCents;
  final int goalInCents;
  final OnboardingStatus status;
  final String? error;

  const OnboardingState({
    required this.step,
    required this.name,
    required this.salaryInCents,
    required this.goalInCents,
    required this.status,
    this.error,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      step: 0,
      name: '',
      salaryInCents: 0,
      goalInCents: 0,
      status: OnboardingStatus.initial,
      error: null,
    );
  }

  OnboardingState copyWith({
    int? step,
    String? name,
    int? salaryInCents,
    int? goalInCents,
    OnboardingStatus? status,
    String? error,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      name: name ?? this.name,
      salaryInCents: salaryInCents ?? this.salaryInCents,
      goalInCents: goalInCents ?? this.goalInCents,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    step,
    name,
    salaryInCents,
    goalInCents,
    status,
    error,
  ];
}

