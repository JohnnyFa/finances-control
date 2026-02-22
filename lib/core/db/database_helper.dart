import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTransactionTable(db);
    await _createRecurringTransactionTable(db);
    await _createUsersTable(db);
    await _createBankConnectionsTable(db);
    await _createBankTransactionsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createUsersTable(db);
    }

    if (oldVersion < 3) {
      await _createBankConnectionsTable(db);
      await _createBankTransactionsTable(db);
      await _addTransactionBankMetadataColumns(db);
    }
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
        month INTEGER NOT NULL,
        source TEXT,
        externalId TEXT,
        bankConnectionId INTEGER
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_year_month
      ON transactions (year, month)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_external_source
      ON transactions (externalId, source)
    ''');
  }

  Future<void> _addTransactionBankMetadataColumns(Database db) async {
    await db.execute('ALTER TABLE transactions ADD COLUMN source TEXT');
    await db.execute('ALTER TABLE transactions ADD COLUMN externalId TEXT');
    await db.execute('ALTER TABLE transactions ADD COLUMN bankConnectionId INTEGER');

    await db.execute('''
      CREATE INDEX idx_transactions_external_source
      ON transactions (externalId, source)
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

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        salary INTEGER NOT NULL,
        amountToSaveByMonth INTEGER,
        email TEXT
        )
    ''');
  }

  Future<void> _createBankConnectionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE bank_connections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bankName TEXT NOT NULL,
        accountMasked TEXT NOT NULL,
        autoSyncEnabled INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createBankTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE bank_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bankConnectionId INTEGER NOT NULL,
        externalId TEXT NOT NULL,
        amount INTEGER NOT NULL,
        description TEXT NOT NULL,
        paidAt TEXT NOT NULL,
        importedAt TEXT NOT NULL,
        UNIQUE(bankConnectionId, externalId)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_bank_transactions_connection
      ON bank_transactions (bankConnectionId)
    ''');
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
