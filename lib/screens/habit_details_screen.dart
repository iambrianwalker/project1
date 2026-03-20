import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import 'edit_habit_screen.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final HabitRepository _habitRepository = HabitRepository();
  late Habit _habit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
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
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _habit.habitName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(_habit.habitDescription),
                  const SizedBox(height: 16),
                  Text('Category: ${_habit.category}'),
                  Text('Frequency: ${_habit.frequency}'),
                  Text('Current Streak: ${_habit.currentStreak}'),
                  Text('Total Completions: ${_habit.totalCompletions}'),
                  if (_habit.imageUrl != null &&
                      _habit.imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Image URL: ${_habit.imageUrl}'),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _editHabit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Habit'),
                  ),
                ],
              ),
            ),
    );
  }
}
