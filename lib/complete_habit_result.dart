import 'models/habit_model.dart';

class CompleteHabitResult {
  final bool success;
  final Habit? updatedhabit;
  final String message;

  CompleteHabitResult({
    required this.success,
    this.updatedhabit,
    required this.message,
  });
}