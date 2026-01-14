import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ExpenseCategorySummary> categories;
  final String? error;
  final int? year;
  final int? month;

  const HomeState({
    required this.status,
    this.categories = const [],
    this.error,
    this.year,
    this.month,
  });

  factory HomeState.initial() => const HomeState(status: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? status,
    List<ExpenseCategorySummary>? categories,
    String? error,
    int? year,
    int? month,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      error: error,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [status, categories, error];
}
