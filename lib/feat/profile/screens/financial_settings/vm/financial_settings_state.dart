enum FinancialSettingsErrorType {
  loadFailed,
  saveFailed,
  salaryGreaterThanZero,
  savingsGreaterThanZero,
}

abstract class FinancialSettingsState {}

class FinancialSettingsLoading extends FinancialSettingsState {}

class FinancialSettingsLoaded extends FinancialSettingsState {
  final int salary;
  final int amountToSave;

  FinancialSettingsLoaded({
    required this.salary,
    required this.amountToSave,
  });

  FinancialSettingsLoaded copyWith({
    int? salary,
    int? amountToSave,
  }) {
    return FinancialSettingsLoaded(
      salary: salary ?? this.salary,
      amountToSave: amountToSave ?? this.amountToSave,
    );
  }
}

class FinancialSettingsError extends FinancialSettingsState {
  final FinancialSettingsErrorType errorType;

  FinancialSettingsError(this.errorType);
}