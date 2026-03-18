import 'package:flutter/cupertino.dart';

class HabitsScreen extends StatefulWidget{
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Habits'),
    );
  }
}

//placeholder habits data
final habits = [
  {
    'id': 1,
    'image_url' : 'imageUrl',
    'habit_name' : 'Study Flutter',
    'habit_description' : 'Spend at least 30 minutes a day learning Flutter and building projects to improve my skills.',
    'category' : 'Education',
    'frequency' : 'Daily',
    'current_streak' : '2',
    'total_completions' : '2',
  },
  {
    'id': 2,
    'image_url' : 'imageUrl',
    'habit_name' : 'Study Dart',
    'habit_description' : 'Spend at least 30 minutes a day learning Dart and building projects to improve my skills.',
    'category' : 'Education',
    'frequency' : 'Daily',
    'current_streak' : '2',
    'total_completions' : '2',
  },
  {
    'id': 3,
    'image_url' : 'imageUrl',
    'habit_name' : 'Study SQLite',
    'habit_description' : 'Spend at least 30 minutes a day learning SQLite and building projects to improve my skills.',
    'category' : 'Education',
    'frequency' : 'Daily',
    'current_streak' : '2',
    'total_completions' : '2',
  },
  {
    'id': 4,
    'image_url' : 'imageUrl',
    'habit_name' : 'Exercise',
    'habit_description' : 'Spend at least 30 minutes a day exercising to improve my physical health and well-being.',
    'category' : 'Health',
    'frequency' : 'Daily',
    'current_streak' : '3',
    'total_completions' : '2',
  },
  {
    'id': 5,
    'image_url' : 'imageUrl',
    'habit_name' : 'Cook Healthy Meals',
    'habit_description' : 'Cook more vegetables!',
    'category' : 'Health',
    'frequency' : 'Daily',
    'current_streak' : '1',
    'total_completions' : '2',
  },
];