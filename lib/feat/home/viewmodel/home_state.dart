import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final int year;
  final int month;

  const HomeLoading({
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [year, month];
}

class HomeLoaded extends HomeState {
  final int year;
  final int month;

  final List<ExpenseCategorySummary> categories;

  final int totalIncome;
  final int totalExpense;
  final int globalEconomy;

  final List<RecurringTransaction> recurring;

  final User user;

  const HomeLoaded({
    required this.year,
    required this.month,
    required this.categories,
    required this.totalIncome,
    required this.totalExpense,
    required this.globalEconomy,
    required this.recurring,
    required this.user,
  });

  int get monthBalance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
    year,
    month,
    categories,
    totalIncome,
    totalExpense,
    globalEconomy,
    recurring,
    user,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}