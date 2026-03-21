import 'package:habit_mastery/repositories/habit_completion_repository.dart';
import 'package:habit_mastery/repositories/habit_repository.dart';
import 'complete_habit_result.dart';
import 'models/habit_model.dart';

class HabitService {
  final HabitRepository habitRepository;
  final HabitCompletionRepository completionRepository;

  HabitService({
    required this.habitRepository,
    required this.completionRepository,
  });

  Future<CompleteHabitResult> completeHabit(Habit habit) async {
    //##TODO this method will check if a habit exists, if it can be completed, and complete it if so
  }

  Future<Habit> refreshHabitStats(Habit habit) async {
    //##TODO this method will recalculate totalCompletions, streak, lastCompletedAt, and isActive
  }

  Future<bool> isHabitCompletableNow(Habit habit) async {
    //##TODO the method uses the hasCompletionForPeriod from completion repository
  }

  bool ShouldBeActive(Habit habit, DateTime now) {
    //##TODO the method will determine if a habit is active or not
  }
}