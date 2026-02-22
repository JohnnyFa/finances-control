import 'package:finances_control/feat/transaction/data/transaction/entity/transaction_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionDao {
  final Database db;

  TransactionDao(this.db);

  Future<void> insert(TransactionEntity tx) async {
    await db.insert('transactions', tx.toMap());
  }

  Future<bool> existsByExternalId(String externalId) async {
    final result = await db.query(
      'transactions',
      columns: ['id'],
      where: 'externalId = ?',
      whereArgs: [externalId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<List<TransactionEntity>> findAll() async {
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map(TransactionEntity.fromMap).toList();
  }

  Future<List<TransactionEntity>> findByMonth({
    required int year,
    required int month,
    bool onlyExpenses = false,
  }) async {
    final where = StringBuffer('year = ? AND month = ?');
    final args = <Object>[year, month];

    if (onlyExpenses) {
      where.write(' AND type = ?');
      args.add('expense');
    }

    final result = await db.query(
      'transactions',
      where: where.toString(),
      whereArgs: args,
      orderBy: 'date DESC',
    );

    return result.map(TransactionEntity.fromMap).toList();
  }
}
