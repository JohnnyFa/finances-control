import 'package:finances_control/feat/open_finance/data/entity/bank_connection_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class BankConnectionDao {
  final Database db;

  BankConnectionDao(this.db);

  Future<void> insert(BankConnectionEntity entity) async {
    await db.insert('bank_connections', entity.toMap());
  }

  Future<List<BankConnectionEntity>> findAll() async {
    final result = await db.query('bank_connections', orderBy: 'createdAt DESC');
    return result.map(BankConnectionEntity.fromMap).toList();
  }
}
