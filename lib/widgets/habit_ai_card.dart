import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../services/habit_analyzer.dart';
import '../services/habit_ai_service.dart';

class HabitAICard extends StatefulWidget {
  final Habit habit;
  final HabitService habitService;

  const HabitAICard({
    super.key,
    required this.habit,
    required this.habitService,
  });

  @override
  State<HabitAICard> createState() => _HabitAICardState();
}