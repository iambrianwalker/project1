import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import 'habit_details_screen.dart';
import 'edit_habit_screen.dart';
import '../widgets/habit_list.dart';
import '../widgets/habit_card.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final HabitRepository _habitRepository = HabitRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Habit> _allHabits = [];
  List<Habit> _filteredHabits = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHabits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final habits = await _habitRepository.getAllHabits();

      setState(() {
        _allHabits = habits;
        _applyFilter();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load habits: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      _filteredHabits = List.from(_allHabits);
      return;
    }

    _filteredHabits = _allHabits.where((habit) {
      final habitName = habit.habitName.toString().toLowerCase();
      final category = habit.category.toString().toLowerCase();

      return habitName.contains(query) || category.contains(query);
    }).toList();
  }

  //navigation now lives here
  //this function will send the user to the edit habit screen
  //then when they click save it will pop them back to habits screen
  //and finally it will refresh the habits screen
  Future<void> _navigateToAddHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditHabitScreen()),
    );

    if (result == true) {
      await _loadHabits();
    }
  }

  Future<void> _navigateToHabitDetails(Habit habit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HabitDetailsScreen(habit: habit)),
    );
  }

  Future<void> _navigateToEditHabit(Habit habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditHabitScreen(habit: habit)),
    );

    if (result == true) {
      await _loadHabits();
    }
  }

  Future<void> _deleteHabit(Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text(
            'Are you sure you want to delete "${habit.habitName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      if (habit.id == null) {
        throw Exception('Habit ID is null. Cannot delete habit.');
      }

      await _habitRepository.deleteHabit(habit.id!);
      await _loadHabits();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${habit.habitName} deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete habit: $e')));
    }
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
                        _applyFilter();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                AddHabitButton(onPressed: _navigateToAddHabit),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  //widget for the body of this screen, responsible for pulling in Habit List
  //and feeding callbacks
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return HabitList(
      habits: _filteredHabits,
      onTap: _navigateToHabitDetails,
      onEdit: _navigateToEditHabit,
      onDelete: _deleteHabit,
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

//search bar widget for habits screen
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

//widget to add a habit
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
