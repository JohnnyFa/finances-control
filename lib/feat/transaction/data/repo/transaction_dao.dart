import 'package:finances_control/feat/transaction/data/transaction_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionDao {
  final Database db;

  TransactionDao(this.db);

  Future<void> insert(TransactionEntity tx) async {
    await db.insert("transactions", tx.toMap());
  }

  Future<List<TransactionEntity>> findAll() async {
    final result = await db.query("transactions", orderBy: "date DESC");
    return result.map(TransactionEntity.fromMap).toList();
  }
}
