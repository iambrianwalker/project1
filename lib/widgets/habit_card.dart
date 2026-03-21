//widget to display a habit card
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_corners.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';

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
      child: InkWell(
        borderRadius: BorderRadius.circular(AppCorners.lg),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitCardHeader(
                habitName: habit.habitName,
                category: habit.category,
              ),
              AppSpacing.gapSm,
              Text(
                habit.habitDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapMd,
              HabitStatsRow(
                frequency: habit.frequency,
                currentStreak: habit.currentStreak,
                totalCompletions: habit.totalCompletions,
              ),
              AppSpacing.gapMd,
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
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.appColors.brand.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppCorners.pill),
          ),
          child: Text(
            category,
            style: context.text.labelMedium?.copyWith(
              color: context.appColors.brand,
              fontWeight: FontWeight.w700,
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
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        HabitStatChip(
          icon: Icons.repeat_rounded,
          label: frequency,
          backgroundColor: context.appColors.surfaceStrong,
          foregroundColor: context.colors.onSurface,
        ),
        HabitStatChip(
          icon: Icons.local_fire_department_rounded,
          label: 'Streak: $currentStreak',
          backgroundColor: context.appColors.streak.withValues(alpha: 0.14),
          foregroundColor: context.appColors.streak,
        ),
        HabitStatChip(
          icon: Icons.check_circle_rounded,
          label: 'Done: $totalCompletions',
          backgroundColor: context.appColors.success.withValues(alpha: 0.14),
          foregroundColor: context.appColors.success,
        ),
      ],
    );
  }
}

//widget for an individual stat chip
class HabitStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const HabitStatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppCorners.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.text.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Edit'),
        ),
        TextButton.icon(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete_rounded,
            size: 18,
            color: context.appColors.danger,
          ),
          label: Text(
            'Delete',
            style: TextStyle(color: context.appColors.danger),
          ),
        ),
      ],
    );
  }
}
