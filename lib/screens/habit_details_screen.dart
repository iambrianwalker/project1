import 'package:flutter/material.dart';

class HabitDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit['habit_name'].toString())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit['habit_name'].toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(habit['habit_description'].toString()),
            const SizedBox(height: 16),
            Text('Category: ${habit['category']}'),
            Text('Frequency: ${habit['frequency']}'),
            Text('Current Streak: ${habit['current_streak']}'),
            Text('Total Completions: ${habit['total_completions']}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit button tapped')),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Habit'),
            ),
          ],
        ),
      ),
    );
  }

  //##TODO widget for displaying visuals of some kind
  //perhaps a calendar heatmap showing when they interact with this habit
}
