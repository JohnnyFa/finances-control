import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('financas_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTransactionTable(db);
    await _createRecurringTransactionTable(db);
  }

  Future<void> _createTransactionTable(Database db) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        year INTEGER NOT NULL,
        month INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_year_month
      ON transactions (year, month)
    ''');
  }

  Future<void> _createRecurringTransactionTable(Database db) async {
    await db.execute('''
    CREATE TABLE recurring_transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount INTEGER NOT NULL,
      type TEXT NOT NULL,
      category TEXT NOT NULL,
      dayOfMonth INTEGER NOT NULL,
      startDate TEXT NOT NULL,
      description TEXT,
      active INTEGER NOT NULL,
      endDate TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE INDEX idx_recurring_active
    ON recurring_transactions (active)
  ''');
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
