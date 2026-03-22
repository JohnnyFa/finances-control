import 'package:finances_control/feat/transaction/domain/category.dart';

class Budget {
  final Category category;
  final int limitCents;
  final int spentCents;
  final int month;
  final int year;

  Budget({
    required this.category,
    required this.limitCents,
    required this.spentCents,
    required this.month,
    required this.year,
  });

  double get percentage => limitCents == 0
      ? 0
      : (spentCents / limitCents) * 100;

  double get progress => limitCents == 0
      ? 0
      : (spentCents / limitCents).clamp(0, 1);

  bool get isOverBudget => spentCents > limitCents;

  int get remainingCents => limitCents - spentCents;

  int get exceededCents =>
      isOverBudget ? spentCents - limitCents : 0;

  Budget copyWith({
    Category? category,
    int? limitCents,
    int? spentCents,
    int? month,
    int? year,
  }) {
    return Budget(
      category: category ?? this.category,
      limitCents: limitCents ?? this.limitCents,
      spentCents: spentCents ?? this.spentCents,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}