import 'package:habit_mastery/repositories/habit_completion_repository.dart';
import 'package:habit_mastery/repositories/habit_repository.dart';
import 'complete_habit_result.dart';
import 'models/habit_completion.dart';
import 'models/habit_model.dart';

class HabitService {
  final HabitRepository habitRepository;
  final HabitCompletionRepository completionRepository;

  HabitService({
    required this.habitRepository,
    required this.completionRepository,
  });

  //this method checks if a habit exists, if it can be completed, and completes it if so
  Future<CompleteHabitResult> completeHabit(Habit habit) async {
    //validate the habit exists
    if (habit.id == null) {
      return CompleteHabitResult(
          success: false,
          message: 'Habit must be saved before it can be completed.');
    }

    final DateTime now = DateTime.now();

    //check if this habit can be completed
    final alreadyCompleted = await completionRepository.hasCompletionForPeriod(
      habitId: habit.id!,
      frequency: habit.frequency,
      now: now,
    );

    if (alreadyCompleted) {
      return CompleteHabitResult(
        success: false,
        updatedHabit: habit,
        message: 'Habit has already been completed for its frequency period.',
      );
    }

    //build habit completion record
    final completion = HabitCompletion(
      habitId: habit.id!,
      completedAt: now,
      createdAt: now,
    );
    //insert habit completion record in habit completions table
    await completionRepository.insertCompletion(completion);
    //await habit to be updated in habits table
    final refreshedHabit = await refreshHabitStats(
        habit.id!,
        now: now,
    );

    //return the complete habit result
    return CompleteHabitResult(
      success: true,
      updatedHabit: refreshedHabit,
      message: 'Habit completed successfully.',
    );
  }

  //this method will recalculate totalCompletions, streak, lastCompletedAt, and isActive
  Future<Habit> refreshHabitStats(int habitId, {DateTime? now}) async {
    final DateTime referenceNow = now ?? DateTime.now();
    final habit = await habitRepository.getHabitByID(habitId);

    if (habit == null) {
      throw Exception('Habit not found for id $habitId');
    }

    //recalculate various values
    final completions = await completionRepository.getCompletionsForHabit(habitId);
    final latestCompletion = await completionRepository.getLatestCompletionForHabit(habitId);
    final totalCompletions = completions.length;
    final currentStreak = _calculateCurrentStreak(
      completions: completions,
      frequency: habit.frequency,
    );

    final updatedHabit = habit.copyWith(
      totalCompletions: totalCompletions,
      currentStreak: currentStreak,
      lastCompletedAt: latestCompletion?.completedAt,
      isActive: shouldBeActive(
        habit.copyWith(lastCompletedAt: latestCompletion?.completedAt),
        referenceNow,
      ),
      updatedAt: referenceNow,
    );

    //update the habit with new values and return from method with the updated habit
    await habitRepository.updateHabit(updatedHabit);
    return updatedHabit;
  }

  //##TODO this method checks whether a completion already exists for the current frequency period
  //returns true only if the habit is allowed to be completed right now
  Future<bool> isHabitCompletableNow(Habit habit) async {
  }

  //##TODO this method will look at all completion records for a habit
  //and determine the actual streak from them
  int _calculateCurrentStreak({
    required List<HabitCompletion> completions,
    required HabitFrequency frequency,
  }) {
  }

  //this method takes a habit and the time stamp from refreshHabitStats
  //it will use this information to see if the user has been completing
  //the particular habit routinely and mark it as active accordingly
  bool shouldBeActive(Habit habit, DateTime now) {
    if (habit.lastCompletedAt == null) return true;

    final difference = now.difference(habit.lastCompletedAt!);

    switch (habit.frequency) {
      case HabitFrequency.daily:
        return difference.inDays < 3;

      case HabitFrequency.weekly:
        return difference.inDays < 14;

      case HabitFrequency.monthly:
        return difference.inDays < 60;
    }
  }

  //##TODO this method will give us the beginning of a habits' frequency period
  //the start of the day if a daily habit, or the start of the week if a weekly habit
  //helper method for calculating current streak
  DateTime _startOfPeriod(DateTime date, HabitFrequency frequency) {
  }

  //##TODO this method will give us the beginning of the period immediately before the given one
  //for a daily habit it would be the start of the prior day, or the previous week start for weekly
  //helper method for calculating current streak
  DateTime _previousPeriodStart(DateTime date, HabitFrequency frequency) {
  }

  //##TODO this method will compare two normalized dates to see if they represent the same period start
  //helper method for calculating current streak
  bool _sameDate(DateTime a, DateTime b) {

  }
}