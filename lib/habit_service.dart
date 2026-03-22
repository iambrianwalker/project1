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

  //this method checks if a completion already exists for the current frequency period
  //returns true only if the habit is allowed to be completed right now
  //useful to adjust the complete button in the UI based on ability to complete habit
  Future<bool> isHabitCompletableNow(Habit habit) async {
    if (habit.id == null) return false;

    final alreadyCompleted = await completionRepository.hasCompletionForPeriod(
        habitId: habit.id!,
        frequency: habit.frequency,
        now: DateTime.now()
    );

    return !alreadyCompleted;
  }

  //this method looks at all completion records for a habit
  //and determines the actual streak count from consecutive completions
  int _calculateCurrentStreak({
    required List<HabitCompletion> completions,
    required HabitFrequency frequency,
  }) {
    if (completions.isEmpty) return 0;

    final completedPeriods = completions
      //normalize to start of the period for the given frequency
      .map((completion) => _startOfPeriod(completion.completedAt, frequency))
      //remove duplicates, defensive, shouldn't exist anyway
      .toSet()
      //back to list for sorting
      .toList()
      //sort newest to oldest
      ..sort((a, b) => b.compareTo(a));

    if (completedPeriods.isEmpty) return 0;

    //count first record to begin streak
    int streak = 1;
    //return previous period
    DateTime expectedPrevious =
      _previousPeriodStart(completedPeriods.first, frequency);
    //loop through the list incrementing streak count until a gap is found
    for (int i = 1; i < completedPeriods.length; i++) {
      if (_sameDate(completedPeriods[i], expectedPrevious)) {
        streak++;
        expectedPrevious = _previousPeriodStart(expectedPrevious, frequency);
      } else {
        break;
      }
    }
    return streak;
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

  //this method gives us the beginning of a habits' frequency period
  //the start of the day if a daily habit, or the start of the week if a weekly habit
  //helper method for calculating current streak
  DateTime _startOfPeriod(DateTime date, HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return DateTime(date.year, date.month, date.day);

      case HabitFrequency.weekly:
        final start = date.subtract(Duration(days: date.weekday - 1));
        return DateTime(start.year, start.month, start.day);

      case HabitFrequency.monthly:
        return DateTime(date.year, date.month, 1);
    }
  }

  //this method gives us the beginning of the period immediately before the given one
  //for a daily habit it would be the start of the prior day, or the previous week start for weekly
  //helper method for calculating current streak
  DateTime _previousPeriodStart(DateTime date, HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return DateTime(date.year, date.month, date.day - 1);

      case HabitFrequency.weekly:
        return DateTime(date.year, date.month, date.day - 7);

      case HabitFrequency.monthly:
        return DateTime(date.year, date.month - 1, 1);
    }
  }

  //this method compares two normalized dates to see if they represent the same period start
  //helper method for calculating current streak
  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
  }
}