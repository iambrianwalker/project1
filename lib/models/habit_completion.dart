class HabitCompletion {
  final int? id;
  final int habitId;
  final DateTime completedAt;
  final DateTime createdAt;

  HabitCompletion({
    this.id,
    required this.habitId,
    required this.completedAt,
    DateTime? createdAt,
    }) : createdAt = createdAt ?? DateTime.now();

  HabitCompletion copyWith({
    int? id,
    int? habitId,
    DateTime? completedAt,
    DateTime? createdAt,
}) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int,
      completedAt: DateTime.parse(map['completed_at'] as String),
      createdAt: map['created_at'] != null
        ? DateTime.parse(map['created_at'] as String)
        : DateTime.now(),
    );
  }
}