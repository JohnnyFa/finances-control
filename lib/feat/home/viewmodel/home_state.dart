import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';

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

  const HomeState({
    required this.status,
    required this.year,
    required this.month,
    required this.categories,
    required this.totalIncome,
    required this.totalExpense,
    this.error,
    required this.globalEconomy,
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
    int? globalEconomy,
  }) {
    return HomeState(
      status: status ?? this.status,
      year: year ?? this.year,
      month: month ?? this.month,
      categories: categories ?? this.categories,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      error: error,
      globalEconomy: globalEconomy ?? this.globalEconomy,
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
  ];
}
