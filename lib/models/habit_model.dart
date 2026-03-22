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

  //this fields will be for internal use going forward
  //they will provide data for our progress things
  final int currentStreak;
  final int totalCompletions;
  final bool isActive;
  final DateTime? lastCompletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;


  Habit({
    this.id,
    this.imageUrl,
    required this.habitName,
    required this.habitDescription,
    required this.category,
    required this.frequency,
    this.currentStreak = 0,
    this.totalCompletions = 0,
    this.isActive = true,
    this.lastCompletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map <String, dynamic> toMap(){
    return {
      'id': id,
      'image_url': imageUrl,
      'habit_name': habitName,
      'habit_description': habitDescription,
      'category': category,
      'frequency': frequency.value,
      'current_streak': currentStreak,
      'total_completions': totalCompletions,
      'is_active': isActive ? 1 : 0,
      'last_completed_at': lastCompletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map){
    return Habit(
      id: map['id'] as int?,
      imageUrl: map['image_url'] as String?,
      habitName: map['habit_name'] as String,
      habitDescription: map['habit_description'] as String,
      category: map['category'] as String,
      frequency: HabitFrequencyExtension.fromString(map['frequency'] as String),
      currentStreak: (map['current_streak'] as int?) ?? 0,
      totalCompletions: (map['total_completions'] as int?) ?? 0,
      isActive: ((map['is_active'] as int?) ?? 1) == 1,
      lastCompletedAt: map['last_completed_at'] != null
          ? DateTime.parse(map['last_completed_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Habit copyWith({
    int? id,
    String? imageUrl,
    String? habitName,
    String? habitDescription,
    String? category,
    HabitFrequency? frequency,
    int? currentStreak,
    int? totalCompletions,
    bool? isActive,
    DateTime? lastCompletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearImageUrl = false,
    bool clearLastCompletedAt = false,
  }) {
    return Habit(
      id: id ?? this.id,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      habitName: habitName ?? this.habitName,
      habitDescription: habitDescription ?? this.habitDescription,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      currentStreak: currentStreak ?? this.currentStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      isActive: isActive ?? this.isActive,
      lastCompletedAt:
      clearLastCompletedAt ? null : (lastCompletedAt ?? this.lastCompletedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}