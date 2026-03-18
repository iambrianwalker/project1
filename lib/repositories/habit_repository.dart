import 'package:sqflite/sqflite.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertHabit(Habit habit) async {
    final db = await _dbHelper.database;
    return db.insert('habits', habit.toMap());
  }
}