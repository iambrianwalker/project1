import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';

class EditHabitScreen extends StatefulWidget {
  //this can be null to allow for using as add habit or edit habit
  final Habit? habit;

  const EditHabitScreen({super.key, this.habit});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final HabitRepository _habitRepository = HabitRepository();

  late final TextEditingController _habitNameController;
  late final TextEditingController _habitDescriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _frequencyController;
  late final TextEditingController _currentStreakController;
  late final TextEditingController _totalCompletionsController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();

    _habitNameController = TextEditingController(
      text: widget.habit?.habitName ?? '',
    );
    _habitDescriptionController = TextEditingController(
      text: widget.habit?.habitDescription ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.habit?.category ?? '',
    );
    _frequencyController = TextEditingController(
      text: widget.habit?.frequency ?? '',
    );
    _currentStreakController = TextEditingController(
      text: widget.habit?.currentStreak.toString() ?? '',
    );
    _totalCompletionsController = TextEditingController(
      text: widget.habit?.totalCompletions.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.habit?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    _habitDescriptionController.dispose();
    _categoryController.dispose();
    _frequencyController.dispose();
    _currentStreakController.dispose();
    _totalCompletionsController.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = habit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Habit' : 'Add Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          isEditing
              ? 'Editing: ${habit!['habit_name']}'
              : 'Add a new habit form goes here',
        ),
      ),
    );
  }
}