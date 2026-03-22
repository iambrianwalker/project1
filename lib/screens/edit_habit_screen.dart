import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';

class EditHabitScreen extends StatefulWidget {
  //this can be null to allow for using as add habit or edit habit
  final Habit? habit;

  const EditHabitScreen({super.key, this.habit});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final HabitRepository _habitRepository = HabitRepository();

  HabitFrequency? _selectedFrequency;

  late final TextEditingController _habitNameController;
  late final TextEditingController _habitDescriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageUrlController;

  bool _isSaving = false;

  bool get _isEditing => widget.habit != null;

  @override
  void initState() {
    super.initState();

    _selectedFrequency = widget.habit?.frequency;

    _habitNameController = TextEditingController(
      text: widget.habit?.habitName ?? '',
    );
    _habitDescriptionController = TextEditingController(
      text: widget.habit?.habitDescription ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.habit?.category ?? '',
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
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFrequency == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final now = DateTime.now();

      final habit = Habit(
        id: widget.habit?.id,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        habitName: _habitNameController.text.trim(),
        habitDescription: _habitDescriptionController.text.trim(),
        category: _categoryController.text.trim(),
        frequency: _selectedFrequency!,
        currentStreak: widget.habit?.currentStreak ?? 0,
        totalCompletions: widget.habit?.totalCompletions ?? 0,
        isActive: widget.habit?.isActive ?? true,
        lastCompletedAt: widget.habit?.lastCompletedAt,
        createdAt: widget.habit?.createdAt ?? now,
        updatedAt: now,
      );

      if (_isEditing) {
        await _habitRepository.updateHabit(habit);
      } else {
        await _habitRepository.insertHabit(habit);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save habit: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _validateFrequency(HabitFrequency? value) {
    if (value == null) {
      return 'Frequency is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Habit' : 'Add Habit')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Text(
                _isEditing
                    ? 'Update your habit details and save your changes.'
                    : 'Create a new mission and start tracking progress.',
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapLg,
              TextFormField(
                controller: _habitNameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator: (value) => _validateRequired(value, 'Habit name'),
              ),
              AppSpacing.gapLg,
              TextFormField(
                controller: _habitDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => _validateRequired(value, 'Description'),
              ),
              AppSpacing.gapLg,
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => _validateRequired(value, 'Category'),
              ),
              AppSpacing.gapLg,
              DropdownButtonFormField<HabitFrequency>(
                initialValue: _selectedFrequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: HabitFrequency.values.map((frequency) {
                  return DropdownMenuItem<HabitFrequency>(
                    value: frequency,
                    child: Text(frequency.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value;
                  });
                },
                validator: _validateFrequency,
              ),
              AppSpacing.gapLg,
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                ),
              ),
              AppSpacing.gapXl,
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveHabit,
                icon: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(_isSaving ? 'Saving...' : 'Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
