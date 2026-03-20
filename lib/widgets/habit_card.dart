//widget to display a habit card
import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitCardHeader(
                habitName: habit.habitName,
                category: habit.category,
              ),
              const SizedBox(height: 8),
              Text(
                habit.habitDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              HabitStatsRow(
                frequency: habit.frequency,
                currentStreak: habit.currentStreak,
                totalCompletions: habit.totalCompletions,
              ),
              const SizedBox(height: 12),
              HabitCardActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

//widget for habit card header
class HabitCardHeader extends StatelessWidget {
  final String habitName;
  final String category;

  const HabitCardHeader({
    super.key,
    required this.habitName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            habitName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

//widget for a row of habit stat chips
class HabitStatsRow extends StatelessWidget {
  final String frequency;
  final int currentStreak;
  final int totalCompletions;

  const HabitStatsRow({
    super.key,
    required this.frequency,
    required this.currentStreak,
    required this.totalCompletions,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        HabitStatChip(icon: Icons.repeat, label: frequency),
        HabitStatChip(
          icon: Icons.local_fire_department,
          label: 'Streak: $currentStreak',
        ),
        HabitStatChip(
          icon: Icons.check_circle,
          label: 'Done: $totalCompletions',
        ),
      ],
    );
  }
}

//widget for an individual stat chip
class HabitStatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const HabitStatChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
    );
  }
}

//widget for habit card actions
class HabitCardActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCardActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Edit'),
        ),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, size: 18),
          label: const Text('Delete'),
        ),
      ],
    );
  }
}
