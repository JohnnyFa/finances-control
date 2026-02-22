import 'package:finances_control/feat/open_finance/data/entity/bank_transaction_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class BankTransactionDao {
  final Database db;

  BankTransactionDao(this.db);

  Future<void> insertIfNotExists(BankTransactionEntity entity) async {
    await db.insert(
      'bank_transactions',
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
