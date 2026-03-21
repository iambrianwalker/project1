import '../database_helper.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  //Create - Insert new habit
  Future<int> insertHabit(Habit habit) async {
    final db = await _dbHelper.database;
    return db.insert('habits', habit.toMap());
  }

  //Read - Get all habits
  Future<List<Habit>> getAllHabits() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');

    return List.generate(maps.length, (i){
      return Habit.fromMap(maps[i]);
    });
  }

  //Read - Get single habit
  Future<Habit?> getHabitByID(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String,dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Habit.fromMap(maps.first);
  }

  //Read - Search for Habits
  Future<List<Habit>> searchHabits(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'habits',
      where: 'habit_name LIKE ?',
      whereArgs: ['%$query%'],
    );

    return maps.map((e) => Habit.fromMap(e)).toList();
  }

  //Read - Get active habits
  Future<List<Habit>> getActiveHabits() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'habits',
      where: 'is_active = ?',
      whereArgs: [1],
    );

    return maps.map((e) => Habit.fromMap(e)).toList();
  }

  //Update - Update existing habit
  Future<int> updateHabit(Habit habit) async {
    final db = await _dbHelper.database;
    return db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  //Delete - Delete a habit
  Future<int> deleteHabit(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}