import '../models/habit_model.dart';

class CompleteHabitResult {
  final bool success;
  final Habit? updatedHabit;
  final String message;

  CompleteHabitResult({
    required this.success,
    this.updatedHabit,
    required this.message,
  });
}