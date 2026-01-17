import 'package:finances_control/feat/transaction/data/recurring_transaction_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class RecurringTransactionDao {
  final Database db;

  RecurringTransactionDao(this.db);

  Future<void> insert(RecurringTransactionEntity e) {
    return db.insert(
      'recurring_transactions',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecurringTransactionEntity>> findAll() async {
    final List<Map<String, Object?>> result =
    await db.query('recurring_transactions');

    return result
        .map((map) => RecurringTransactionEntity.fromMap(map))
        .toList();
  }

  Future<List<RecurringTransactionEntity>> findActive() async {
    final List<Map<String, Object?>> result = await db.query(
      'recurring_transactions',
      where: 'active = 1',
    );

    return result
        .map((map) => RecurringTransactionEntity.fromMap(map))
        .toList();
  }
}
