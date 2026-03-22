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
    final allBudgetMaps = await _db.query('category_budgets');

    final allBudgets = allBudgetMaps
        .map((m) => CategoryBudgetEntity.fromMap(m))
        .toList();

    final Map<String, CategoryBudgetEntity> latestByCategory = {};

    for (final b in allBudgets) {
      final existing = latestByCategory[b.categoryId];

      if (existing == null) {
        latestByCategory[b.categoryId] = b;
      } else {
        final existingDate = DateTime(existing.year, existing.month);
        final currentDate = DateTime(b.year, b.month);

        if (currentDate.isAfter(existingDate)) {
          latestByCategory[b.categoryId] = b;
        }
      }
    }

    final exactMatches = allBudgets.where((b) {
      return b.month == month && b.year == year;
    }).toList();

    final spentMaps = await _db.rawQuery(
      '''
    SELECT category, SUM(amount) as spent_cents
    FROM transactions
    WHERE month = ? AND year = ? AND type = 'expense'
    GROUP BY category
  ''',
      [month, year],
    );

    final spentPerCategory = {
      for (var m in spentMaps) m['category'] as String: m['spent_cents'] as int,
    };

    final List<Budget> result = [];

    for (final category in Category.values) {
      CategoryBudgetEntity? entity;

      for (final e in exactMatches) {
        if (e.categoryId == category.name) {
          entity = e;
          break;
        }
      }

      entity ??= latestByCategory[category.name];

      if (entity != null) {
        result.add(
          Budget(
            category: category,
            limitCents: entity.limitCents,
            spentCents: spentPerCategory[entity.categoryId] ?? 0,
            month: month,
            year: year,
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<void> upsertBudget(
    String categoryId,
    int month,
    int year,
    int limitCents,
  ) async {
    final entity = CategoryBudgetEntity(
      categoryId: categoryId,
      month: month,
      year: year,
      limitCents: limitCents,
    );

    await _db.transaction((txn) async {
      await txn.insert(
        'category_budgets',
        entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        'category_budgets',
        where: '''
        category_id = ? AND (
          year > ? OR (year = ? AND month > ?)
        )
      ''',
        whereArgs: [categoryId, year, year, month],
      );
    });
  }

  @override
  Future<void> deleteBudget(String categoryId, int month, int year) async {
    await _db.delete(
      'category_budgets',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }
}
