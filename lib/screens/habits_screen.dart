import 'package:flutter/material.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HabitsTitle(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: HabitsSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                AddHabitButton(
                  onPressed: () {
                    //##TODO navigate to add habit screen
                    //temp demonstrate button pressed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Habit button pressed')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            //##TODO display list of habit cards based on search query
            //temp display search query
            Text('Search query: $_searchQuery'),
          ],
        ),
      ),
    );
  }
}

//widget for page title
class HabitsTitle extends StatelessWidget {
  const HabitsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Habits', style: Theme.of(context).textTheme.headlineMedium);
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}

//##TODO widget to add a habit
class AddHabitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddHabitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text('Add Habit'),
    );
  }
}

//widget to display a habit card
class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitCardHeader(
                habitName: habit['habit_name'].toString(),
                category: habit['category'].toString(),
              ),
              const SizedBox(height: 8),
              Text(
                habit['habit_description'].toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              HabitStatsRow(
                frequency: habit['frequency'].toString(),
                currentStreak: habit['current_streak'].toString(),
                totalCompletions: habit['total_completions'].toString(),
              ),
              const SixedBox(height: 12),
              HabitCardActions(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//widget for habit card header

//widget for habit stats

//widget for habit card actions

//##TODO widget to display a list of habit cards

//placeholder habits data
final habits = [
  {
    'id': 1,
    'image_url': 'imageUrl',
    'habit_name': 'Study Flutter',
    'habit_description':
        'Spend at least 30 minutes a day learning Flutter and building projects to improve my skills.',
    'category': 'Education',
    'frequency': 'Daily',
    'current_streak': '2',
    'total_completions': '2',
  },
  {
    'id': 2,
    'image_url': 'imageUrl',
    'habit_name': 'Study Dart',
    'habit_description':
        'Spend at least 30 minutes a day learning Dart and building projects to improve my skills.',
    'category': 'Education',
    'frequency': 'Daily',
    'current_streak': '2',
    'total_completions': '2',
  },
  {
    'id': 3,
    'image_url': 'imageUrl',
    'habit_name': 'Study SQLite',
    'habit_description':
        'Spend at least 30 minutes a day learning SQLite and building projects to improve my skills.',
    'category': 'Education',
    'frequency': 'Daily',
    'current_streak': '2',
    'total_completions': '2',
  },
  {
    'id': 4,
    'image_url': 'imageUrl',
    'habit_name': 'Exercise',
    'habit_description':
        'Spend at least 30 minutes a day exercising to improve my physical health and well-being.',
    'category': 'Health',
    'frequency': 'Daily',
    'current_streak': '3',
    'total_completions': '2',
  },
  {
    'id': 5,
    'image_url': 'imageUrl',
    'habit_name': 'Cook Healthy Meals',
    'habit_description': 'Cook more vegetables!',
    'category': 'Health',
    'frequency': 'Daily',
    'current_streak': '1',
    'total_completions': '2',
  },
];
