import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
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
    await _createHabitsTable(db);
    await _createHabitCompletionsTable(db);
    await _createHabitCompletionIndexes(db);
  }

  Future<void> _createHabitsTable(Database db) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_url TEXT,
        habit_name TEXT NOT NULL,
        habit_description TEXT NOT NULL,
        category TEXT NOT NULL,
        frequency TEXT NOT NULL,
        current_streak INTEGER NOT NULL DEFAULT 0,
        total_completions INTEGER NOT NULL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        last_completed_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }
  Future<void> _createHabitCompletionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE habit_completions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE
      )
      ''');
  }

  Future<void> _createHabitCompletionIndexes(Database db) async {
    await db.execute('''
      CREATE INDEX idx_habit_completions_habit_id
      ON habit_completions(habit_id)      
    ''');

    await db.execute('''
      CREATE INDEX idx_habit_completions_habit_id_completed_at
      ON habit_completions(habit_id, completed_at)    
    ''');
  }

  //testing method below here
  Future<void> printDatabaseContents() async {
    final db = await database;

    print('=== HABITS ===');
    final habits = await db.query('habits');
    for (final habit in habits) {
      print(habit);
    }

    print('=== HABIT COMPLETIONS ===');
    final completions = await db.query('habit_completions');
    for (final completion in completions) {
      print(completion);
    }
  }
}