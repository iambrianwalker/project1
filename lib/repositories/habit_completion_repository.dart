import 'package:habit_mastery/database_helper.dart';
import 'package:habit_mastery/models/habit_model.dart';
import '../models/habit_completion.dart';

class HabitCompletionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertCompletion(HabitCompletion completion) async {
    //##TODO this function should add one completion event
  }

  Future<List<HabitCompletion>> getCompletionsForHabit(int habitId) async {
    //##TODO this function should let us grab all completion history for a habit
  }

  Future<List<HabitCompletion>> getCompletionsForHabitInRange(
      int habitId,
      DateTime start,
      DateTime end
      ) async {
    //##TODO by giving this function a habit and a date range
    //it will return a list of completion records for that habit
    //in that date range
    //useful for progress charts, weekly summaries, calendar heatmaps
  }

  Future<HabitCompletion?> getLatestCompletionForHabit(int habitId) async {
    //##TODO this method will return the latest completion record
    //based on lastCompletedAt
  }

  Future<int> getCompletionCountForHabit(int habitId) async {
    //##TODO this method will provide us with the total number of completion records for a habit
    //useful for syncing up totalCompletions based on completion records for a habit
  }

  Future<bool> hasCompletionForPeriod(
      int habitId,
      HabitFrequency frequency,
      DateTime now
      ) async {
    //##TODO this method will decide if a habit has already been completed for the
    //given frequency of that habit
  }

  Future<int> deleteCompletion(int completionId) async {
    //##TODO this method will delete a completion record
  }

  Future<int> deleteCompletionsForHabit(int habitId) async {
    //##TODO this method will delete all completion records for a habit
    //on delete cascade paired with foreign keys may do this methods job though
  }
}