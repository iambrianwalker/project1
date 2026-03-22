import 'habit_service.dart';
import '../models/habit_model.dart';

class HabitAnalysis{
  final int streak;
  final int total;
  final bool isActive;
  final int daysSinceLast;

  HabitAnalysis({
    required this.streak,
    required this.total,
    required this.isActive,
    required this.daysSinceLast,
  });
}

class HabitAnalyzer{
  final HabitService habitService;

  HabitAnalyzer(this.habitService);

  Future<HabitAnalysis> analyze(Habit habit) async {
    final refreshed = await habitService.refreshHabitStats(habit.id!);

    int daysSinceLast = 999;
    if(refreshed.lastCompletedAt != null) {
      daysSinceLast =
        DateTime.now().difference(refreshed.lastCompletedAt!).inDays;
    }

    return HabitAnalysis(
      streak: refreshed.currentStreak,
      total: refreshed.totalCompletions,
      isActive: refreshed.isActive,
      daysSinceLast: daysSinceLast,
    );
  }
}