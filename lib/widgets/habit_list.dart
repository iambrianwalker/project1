//widget to display a list of habit cards
import 'package:flutter/material.dart';
import 'habit_card.dart';

class HabitList extends StatelessWidget {
  final List<Map<String, dynamic>> habits;

  const HabitList({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Center(child: Text('No habits found.'));
    }

    return ListView.separated(
      itemCount: habits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];

        return HabitCard(
          habit: habit,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailsScreen(habit: habit),
              ),
            );
          },
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditHabitScreen(habit: habit),
              ),
            );
          },
          onDelete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Delete ${habit['habit_name']}')),
            );
          },
        );
      },
    );
  }
}