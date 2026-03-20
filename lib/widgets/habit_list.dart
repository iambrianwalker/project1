//widget to display a list of habit cards
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import 'habit_card.dart';

class HabitList extends StatelessWidget {
  final List<Habit> habits;
  final void Function(Habit habit) onTap;
  final void Function(Habit habit) onEdit;
  final void Function(Habit habit) onDelete;

  const HabitList({
    super.key,
    required this.habits,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

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
          onTap: () => onTap(habit),
          onEdit: () => onEdit(habit),
          onDelete: () => onDelete(habit),
        );
      },
    );
  }
}
