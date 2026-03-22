import 'package:finances_control/feat/budget_control/data/model/category_budget_entity.dart';
import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:sqflite/sqflite.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final Database _db;

  BudgetRepositoryImpl(this._db);

  @override
  Future<List<Budget>> getBudgetsByMonth(int month, int year) async {
    // 1. Fetch budgets for the month/year
    final budgetMaps = await _db.query(
      'category_budgets',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
    );

    final budgetEntities = budgetMaps.map((m) => CategoryBudgetEntity.fromMap(m)).toList();

    // 2. Fetch spent amount per category for the same month/year
    // We use a query that sums transactions of type 'expense'
    final spentMaps = await _db.rawQuery('''
      SELECT category, SUM(amount) as spent_cents
      FROM transactions
      WHERE month = ? AND year = ? AND type = 'expense'
      GROUP BY category
    ''', [month, year]);

    final spentPerCategory = {
      for (var m in spentMaps) m['category'] as String: m['spent_cents'] as int
    };

    // 3. Map to Domain model
    return budgetEntities.map((entity) {
      final category = Category.values.firstWhere(
        (c) => c.name == entity.categoryId,
        orElse: () => Category.others,
      );

      return Budget(
        category: category,
        limitCents: entity.limitCents,
        spentCents: spentPerCategory[entity.categoryId] ?? 0,
        month: entity.month,
        year: entity.year,
      );
    }).toList();
  }

  @override
  Future<void> upsertBudget(String categoryId, int month, int year, int limitCents) async {
    final entity = CategoryBudgetEntity(
      categoryId: categoryId,
      month: month,
      year: year,
      limitCents: limitCents,
    );

    await _db.insert(
      'category_budgets',
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteBudget(String categoryId, int month, int year) async {
    await _db.delete(
      'category_budgets',
      where: 'category_id = ? AND month = ? AND year = ?',
      whereArgs: [categoryId, month, year],
    );
  }
}
