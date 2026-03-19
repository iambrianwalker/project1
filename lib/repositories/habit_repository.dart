import '../database_helper.dart';
import 'package:sqflite/sqflite.dart';
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
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Habit.fromMap(maps.first);
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

  
}