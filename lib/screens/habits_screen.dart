import 'package:flutter/material.dart';

class HabitsScreen extends StatefulWidget{
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>{
  //text edit controller for search bar
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
      _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Habits'),
    );
  }
}

//widget for page title
class HabitsTitle extends StatelessWidget {
  const HabitsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Habits',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

//##TODO search bar widget for habits screen
class HabitsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const HabitsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search habits',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }
}

//##TODO widget to add a habit

//##TODO widget to display a habit card

//##TODO widget to display a list of habit cards

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