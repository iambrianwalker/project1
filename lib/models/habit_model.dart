class Habit{
  final int? id;
  final String? imageUrl;
  final String habitName;
  final String habitDescription;
  final String category;
  final String frequency;
  final int currentStreak;
  final int totalCompletions;
  //bool isActive;

  Habit({
    this.id,
    this.imageUrl,
    required this.habitName,
    required this.habitDescription,
    required this.category,
    required this.frequency,
    required this.currentStreak,
    required this.totalCompletions,
    //this.isActive = false,
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

  factory Habit.fromMap(Map<String, dynamic> map){
    return Habit(
      id: map['id'],
      imageUrl: map['image_url'],
      habitName: map['habit_name'],
      habitDescription: map['habit_description'],
      category: map['category'],
      frequency: map['frequency'],
      currentStreak: map['current_streak'],
      totalCompletions: map['total_completions'],
    );
  }

  Habit copyWith({
    int? id,
    String? imageUrl,
    String? habitName,
    String? habitDescription,
    String? category,
    String? frequency,
    int? currentStreak,
    int? totalCompletions
  }) {
    return Habit(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      habitName: habitName ?? this.habitName,
      habitDescription: habitDescription ?? this.habitDescription,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      currentStreak: currentStreak ?? this.currentStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
    );
  }
}