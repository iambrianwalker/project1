import 'package:flutter/material.dart';

class EditHabitScreen extends StatelessWidget {
  //this can be null to allow for using as add habit or edit habit
  final Map<String, dynamic>? habit;

  const EditHabitScreen({super.key, this.habit});

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
