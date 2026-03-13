class Habit{
  final int? id;
  final String habitName;
  final String habitDescription;
  final String category;
  final String frequency;
  final String currentStreak;
  final String totalCompletions;

  Habit({
    this.id,
    required this.habitName,
    required this.habitDescription,
    required this.category,
    required this.frequency,
    required this.currentStreak,
    required this.totalCompletions,
  });
}