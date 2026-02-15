import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final int globalEconomy;
  final HomeStatus status;
  final int year;
  final int month;

  final List<ExpenseCategorySummary> categories;

  final int totalIncome;
  final int totalExpense;

  final String? error;
  final List<RecurringTransaction> recurring;
  final User user;

  const HomeState({
    required this.status,
    required this.year,
    required this.month,
    required this.categories,
    required this.totalIncome,
    required this.totalExpense,
    this.error,
    required this.globalEconomy,
    required this.recurring,
    required this.user,
  });

  int get monthBalance => totalIncome - totalExpense;

  factory HomeState.initial() {
    final now = DateTime.now();
    return HomeState(
      status: HomeStatus.initial,
      year: now.year,
      month: now.month,
      categories: const [],
      totalIncome: 0,
      totalExpense: 0,
      globalEconomy: 0,
      recurring: const [],
      user: User.empty(),
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    int? year,
    int? month,
    List<ExpenseCategorySummary>? categories,
    int? totalIncome,
    int? totalExpense,
    String? error,
    bool clearError = false,
    int? globalEconomy,
    List<RecurringTransaction>? recurring,
    User? user,
  }) {
    return HomeState(
      status: status ?? this.status,
      year: year ?? this.year,
      month: month ?? this.month,
      categories: categories ?? this.categories,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      error: clearError ? null : error ?? this.error,
      globalEconomy: globalEconomy ?? this.globalEconomy,
      recurring: recurring ?? this.recurring,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    status,
    year,
    month,
    categories,
    totalIncome,
    totalExpense,
    error,
    globalEconomy,
    recurring,
    user,
  ];
}
