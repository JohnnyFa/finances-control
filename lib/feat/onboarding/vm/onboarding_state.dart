import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, loading, success, error }

class OnboardingState extends Equatable {
  final int step;

  final String name;
  final int salaryInCents;
  final int goalInCents;

  final bool isNameValid;
  final bool isSalaryValid;
  final bool isGoalValid;

  final OnboardingStatus status;
  final String? validationError;

  const OnboardingState({
    required this.step,
    required this.name,
    required this.salaryInCents,
    required this.goalInCents,
    required this.isNameValid,
    required this.isSalaryValid,
    required this.isGoalValid,
    required this.status,
    required this.validationError,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      step: 0,
      name: '',
      salaryInCents: 0,
      goalInCents: 0,
      isNameValid: false,
      isSalaryValid: false,
      isGoalValid: true,
      validationError: null,
      status: OnboardingStatus.initial,
    );
  }

  OnboardingState copyWith({
    int? step,
    String? name,
    int? salaryInCents,
    int? goalInCents,
    bool? isNameValid,
    bool? isSalaryValid,
    bool? isGoalValid,
    OnboardingStatus? status,
    String? validationError,
    bool clearValidationError = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      name: name ?? this.name,
      salaryInCents: salaryInCents ?? this.salaryInCents,
      goalInCents: goalInCents ?? this.goalInCents,
      isNameValid: isNameValid ?? this.isNameValid,
      isSalaryValid: isSalaryValid ?? this.isSalaryValid,
      isGoalValid: isGoalValid ?? this.isGoalValid,
      status: status ?? this.status,
      validationError: clearValidationError
          ? null
          : validationError ?? this.validationError,
    );
  }

  @override
  List<Object?> get props => [
    step,
    name,
    salaryInCents,
    goalInCents,
    isNameValid,
    isSalaryValid,
    isGoalValid,
    status,
    validationError,
  ];
}
