/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = "databaze_maturitni_prace.db";
  static const _dbVersion = 1;
  static const _tableName = "Uzivatel";

  // Singleton instance
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializace databáze
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // Vytvoření tabulky
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Jmeno TEXT NOT NULL,
        Email TEXT NOT NULL UNIQUE,
        Heslo TEXT NOT NULL
      )
    ''');
  }
}*/