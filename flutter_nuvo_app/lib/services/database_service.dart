import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'nuvo_local.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // User Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT,
        lastname TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT,
        phoneNumber TEXT UNIQUE
      )
    ''');

    // Account Table
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL UNIQUE,
        accountNumber TEXT NOT NULL UNIQUE,
        balance REAL NOT NULL,
        createdAt TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Transaction Table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sourceUserId INTEGER,
        targetUserId INTEGER,
        amount REAL NOT NULL,
        type TEXT,
        timestamp TEXT,
        FOREIGN KEY (sourceUserId) REFERENCES users (id),
        FOREIGN KEY (targetUserId) REFERENCES users (id)
      )
    ''');

    // Loan Table
    await db.execute('''
      CREATE TABLE loans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        amount REAL NOT NULL,
        termMonths INTEGER NOT NULL,
        interestRate REAL NOT NULL,
        status TEXT,
        createdAt TEXT,
        approvedAt TEXT,
        paidAmount REAL NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Pool Table
    await db.execute('''
      CREATE TABLE pools (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        interestRatePerDay REAL NOT NULL,
        maxParticipants INTEGER NOT NULL,
        active INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Investment Table
    await db.execute('''
      CREATE TABLE investments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        investedAmount REAL NOT NULL,
        investedAt TEXT NOT NULL,
        status TEXT,
        poolId INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (poolId) REFERENCES pools (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
