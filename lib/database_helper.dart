import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('habit_mastery.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_url TEXT,
        habit_name TEXT NOT NULL,
        habit_description TEXT NOT NULL,
        category TEXT NOT NULL,
        frequncy TEXT NOT NULL,
        current_streak INTEGER NOT NULL,
        total_completions INTEGER NOT NULL
      )
      '''
    );
  }

  //testing method below here
  Future<void> printDatabaseContents() async {
    final db = await database;

    print('=== HABITS ===');
    final habits = await db.query('habits');
    for (final habit in habits) {
      print(habits);
    }
  }
}