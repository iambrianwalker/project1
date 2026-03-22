import 'package:flutter/material.dart';
import 'package:habit_mastery/services/habit_service.dart';
import 'package:habit_mastery/models/habit_completion.dart';
import 'package:habit_mastery/repositories/habit_completion_repository.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import '../theme/app_corners.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';
import 'edit_habit_screen.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final HabitRepository _habitRepository = HabitRepository();
  final HabitCompletionRepository _completionRepository =
      HabitCompletionRepository();
  late final HabitService _habitService;
  late Habit _habit;
  bool _isLoading = false;
  bool _canCompleteHabit = false;
  List<HabitCompletion> _recentCompletions = [];

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
    _habitService = HabitService(
      habitRepository: _habitRepository,
      completionRepository: _completionRepository,
    );
    _loadScreenData();
  }

  Future<void> _loadScreenData() async {
    await Future.wait([_refreshCompletableState(), _loadRecentCompletions()]);
  }

  Future<void> _refreshCompletableState() async {
    final canComplete = await _habitService.isHabitCompletableNow(_habit);

    if (!mounted) return;

    setState(() {
      _canCompleteHabit = canComplete;
    });
  }

  Future<void> _loadRecentCompletions() async {
    if (_habit.id == null) return;

    final completions = await _completionRepository.getCompletionsForHabit(
      _habit.id!,
    );

    if (!mounted) return;

    setState(() {
      _recentCompletions = completions.take(5).toList();
    });
  }

  Future<void> _completeHabit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _habitService.completeHabit(_habit);

      if (!mounted) return;

      if (result.success && result.updatedHabit != null) {
        setState(() {
          _habit = result.updatedHabit!;
        });

        await _refreshCompletableState();
        await _loadRecentCompletions();
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to complete habit: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _editHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditHabitScreen(habit: _habit)),
    );

    if (result == true && _habit.id != null) {
      await _reloadHabit();
    }
  }

  Future<void> _reloadHabit() async {
    if (_habit.id == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final refreshedHabit = await _habitRepository.getHabitByID(_habit.id!);

      if (refreshedHabit != null) {
        setState(() {
          _habit = refreshedHabit;
        });

        await _refreshCompletableState();
        await _loadRecentCompletions();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to refresh habit: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_habit.habitName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AppSpacing.screenPadding,
              children: [
                Text(
                  _habit.habitName,
                  style: context.text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  _habit.habitDescription,
                  style: context.text.bodyLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapLg,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _DetailChip(
                      icon: Icons.category_rounded,
                      label: _habit.category,
                      backgroundColor: context.appColors.brand.withValues(
                        alpha: 0.12,
                      ),
                      foregroundColor: context.appColors.brand,
                    ),
                    _DetailChip(
                      icon: Icons.repeat_rounded,
                      label: _habit.frequency.label,
                      backgroundColor: context.appColors.surfaceStrong,
                      foregroundColor: context.colors.onSurface,
                    ),
                    _DetailChip(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Streak: ${_habit.currentStreak}',
                      backgroundColor: context.appColors.streak.withValues(
                        alpha: 0.14,
                      ),
                      foregroundColor: context.appColors.streak,
                    ),
                    _DetailChip(
                      icon: Icons.check_circle_rounded,
                      label: 'Done: ${_habit.totalCompletions}',
                      backgroundColor: context.appColors.success.withValues(
                        alpha: 0.14,
                      ),
                      foregroundColor: context.appColors.success,
                    ),
                  ],
                ),
                AppSpacing.gapXl,
                _InfoSection(
                  title: 'Details',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(label: 'Category', value: _habit.category),
                      AppSpacing.gapMd,
                      _InfoRow(
                        label: 'Frequency',
                        value: _habit.frequency.label,
                      ),
                      AppSpacing.gapMd,
                      _InfoRow(
                        label: 'Current Streak',
                        value: _habit.currentStreak.toString(),
                      ),
                      AppSpacing.gapMd,
                      _InfoRow(
                        label: 'Total Completions',
                        value: _habit.totalCompletions.toString(),
                      ),
                    ],
                  ),
                ),
                if (_recentCompletions.isNotEmpty) ...[
                  AppSpacing.gapLg,
                  _InfoSection(
                    title: 'Recent Completions',
                    child: _recentCompletions.isEmpty
                        ? Text(
                            'You have no completions for this habit yet.',
                            style: context.text.bodyMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          )
                        : Column(
                            children: _recentCompletions.map((completion) {
                              final completedAt = completion.completedAt;
                              final dateText =
                                  '${completedAt.month}/${completedAt.day}/${completedAt.year}';
                              final timeText =
                                  '${completedAt.hour.toString().padLeft(2, '0')}:${completedAt.minute.toString().padLeft(2, '0')}';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: context.appColors.success,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        dateText,
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      timeText,
                                      style: context.text.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
                if (_habit.imageUrl != null && _habit.imageUrl!.isNotEmpty) ...[
                  AppSpacing.gapLg,
                  _InfoSection(
                    title: 'Image URL',
                    child: SelectableText(
                      _habit.imageUrl!,
                      style: context.text.bodyMedium,
                    ),
                  ),
                ],
                AppSpacing.gapXl,
                ElevatedButton.icon(
                  onPressed: (_isLoading || !_canCompleteHabit)
                      ? null
                      : _completeHabit,
                  icon: Icon(
                    _canCompleteHabit
                        ? Icons.check_circle_rounded
                        : Icons.task_alt_rounded,
                  ),
                  label: Text(
                    _canCompleteHabit
                        ? 'Complete habit'
                        : 'Completed already, yay!',
                  ),
                ),
                AppSpacing.gapMd,
                ElevatedButton.icon(
                  onPressed: _editHabit,
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit Habit'),
                ),
              ],
            ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapMd,
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _DetailChip({
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
        borderRadius: BorderRadius.circular(AppCorners.pill),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
