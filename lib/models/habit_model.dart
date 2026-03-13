class Habit{
  final int? id;
  final String? imageUrl;
  final String habitName;
  final String habitDescription;
  final String category;
  final String frequency;
  final String currentStreak;
  final String totalCompletions;

  Habit({
    this.id,
    this.imageUrl,
    required this.habitName,
    required this.habitDescription,
    required this.category,
    required this.frequency,
    required this.currentStreak,
    required this.totalCompletions,
  });

  Map <String, dynamic> toMap(){
    return {
      'id' : id,
      'image_url' : imageUrl,
      'habit_name' : habitName,
      'habit_description' : habitDescription,
      'category' : category,
      'frequency' : frequency,
      'current_streak' : currentStreak,
      'total_completions' : totalCompletions,
    };
  }
}