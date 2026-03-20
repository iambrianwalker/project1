//using a enum for frequency instead of string for predicatable and powerful logic
enum HabitFrequency {
  daily,
  weekly,
  monthly,
}

extension HabitFrequencyExtension on HabitFrequency {
  //this will convert our enum into a string primarily for storing in the SQLite table
  String get value {
    switch (this) {
      case HabitFrequency.daily:
        return 'daily';
      case HabitFrequency.weekly:
        return 'weekly';
      case HabitFrequency.monthly:
        return 'monthly';
    }
  }

  //and here we do the opposite. SQLite will give us a string and we will
  //convert into our enum
  static HabitFrequency fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return HabitFrequency.daily;
      case 'weekly':
        return HabitFrequency.weekly;
      case 'monthly':
        return HabitFrequency.monthly;
      default:
        throw ArgumentError('Invalid habit frequency: $value');
    }
  }

  //lastly, this is for displaying our enum as text in the UI
  String get label {
    switch (this) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
    }
  }
}

class Habit{
  final int? id;
  final String? imageUrl;
  final String habitName;
  final String habitDescription;
  final String category;
  final HabitFrequency frequency;
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