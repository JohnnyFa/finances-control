import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;
  final int month;
  final int year;

  const BudgetLoaded({
    required this.budgets,
    required this.month,
    required this.year,
  });

  int get totalLimit => budgets.fold(0, (sum, b) => sum + b.limitCents);
  int get totalSpent => budgets.fold(0, (sum, b) => sum + b.spentCents);
  double get totalPercentage => totalLimit == 0 ? 0 : (totalSpent / totalLimit * 100).clamp(0, 100);

  @override
  List<Object?> get props => [budgets, month, year];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}
