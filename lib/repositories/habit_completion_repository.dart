import 'package:habit_mastery/database_helper.dart';
import 'package:habit_mastery/models/habit_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/habit_completion.dart';

class HabitCompletionRepository {
  static const String tableName = 'habit_completions';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  //this function should add one completion event
  Future<int> insertCompletion(HabitCompletion completion) async {
    final db = await _dbHelper.database;

    return await db.insert(
      tableName,
      completion.toMap(),
    );
  }

  //this function should let us grab all completion history for a habit
  Future<List<HabitCompletion>> getCompletionsForHabit(int habitId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      tableName,
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'completed_at DESC',
    );

    return maps.map(HabitCompletion.fromMap).toList();
  }

  //by giving this function a habit and a date range
  //it will return a list of completion records for that habit
  //in that date range
  //useful for progress charts, weekly summaries, calendar heatmaps
  Future<List<HabitCompletion>> getCompletionsForHabitInRange(
      int habitId,
      DateTime start,
      DateTime end
      ) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      tableName,
      where: 'habit_id = ? AND completed_at >= ? AND completed_at < ?',
      whereArgs: [
        habitId,
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'completed_at ASC',
    );
    return maps.map(HabitCompletion.fromMap).toList();
  }

  //this method will return the latest completion record
  Future<HabitCompletion?> getLatestCompletionForHabit(int habitId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      tableName,
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'completed_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return HabitCompletion.fromMap(maps.first);
  }

  //this method will provide us with the total number of completion records for a habit
  //useful for syncing up totalCompletions based on completion records for a habit
  Future<int> getCompletionCountForHabit(int habitId) async {
    final db = await _dbHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT (*) as count FROM $tableName WHERE habit_id = ?',
      [habitId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //this method will decide if a habit has already been completed
  //for the given frequency of that habit
  Future<bool> hasCompletionForPeriod({
    required int habitId,
    required HabitFrequency frequency,
    DateTime? now
    }) async {
    final reference = now ?? DateTime.now();
    final start = _startOfPeriod(reference, frequency);
    final end = _endOfPeriod(reference, frequency);

    final completions = await getCompletionsForHabitInRange(habitId, start, end);
    return completions.isNotEmpty;
  }

  //this utilizes DateTime to return clean values for our time period check
  DateTime _startOfPeriod(DateTime date, HabitFrequency frequency) {
    switch (frequency) {
      //returns current days' date but at moment it began, midnight
      case HabitFrequency.daily:
        return DateTime(date.year, date.month, date.day);

      //goes back to monday and returns the current weeks' Monday DateTime
        case HabitFrequency.weekly:
        final start = date.subtract(Duration(days: date.weekday - 1));
        return DateTime(start.year, start.month, start.day);

      //goes back to start of current month and returns first day DateTime
        case HabitFrequency.monthly:
        return DateTime(date.year, date.month, 1);
    }
  }

  DateTime _endOfPeriod(DateTime date, HabitFrequency frequency) {
    switch (frequency) {
      //adds one day to current day which gives us the start of the next day
      case HabitFrequency.daily:
        return DateTime(date.year, date.month, date.day + 1);

      //uses previous method to find date for this weeks' monday then adds 7 to it to find next weeks' monday DateTime
        case HabitFrequency.weekly:
        final start = _startOfPeriod(date, HabitFrequency.weekly);
        return start.add(const Duration(days: 7));

      //gives us Jan 1 of next year, or gives us day 1 of the next month of current year
        case HabitFrequency.monthly:
        if (date.month == 12) {
          return DateTime(date.year +1, 1, 1);
        }
        return DateTime(date.year, date.month + 1, 1);
    }
  }

  //this method will delete a completion record
  Future<int> deleteCompletion(int completionId) async {
    final db = await _dbHelper.database;

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [completionId],
    );
  }

  //this method will delete all completion records for a habit
  //on delete cascade paired with foreign keys may do this methods job though
  Future<int> deleteCompletionsForHabit(int habitId) async {
    final db = await _dbHelper.database;

    return await db.delete(
      tableName,
      where: 'habit_id = ?',
      whereArgs: [habitId],
    );
  }
}