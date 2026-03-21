//widget to display a list of habit cards
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';
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
      return Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 56,
                color: context.appColors.brand.withValues(alpha: 0.8),
              ),
              AppSpacing.gapMd,
              Text(
                'No habits found',
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                'Tap Add Habit to create your first mission.',
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: habits.length,
      separatorBuilder: (_, _) => AppSpacing.gapMd,
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
