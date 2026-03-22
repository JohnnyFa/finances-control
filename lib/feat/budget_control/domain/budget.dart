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

  double get percentage => (spentCents / limitCents * 100).clamp(0, 100);
  bool get isOverBudget => spentCents > limitCents;
  int get remainingCents => limitCents - spentCents;

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
