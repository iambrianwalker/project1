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

class _HabitAICardState extends State<HabitAICard> {
  String? message;
  String? goal;
  bool isLoading = true;

  late HabitAnalyzer analyzer;
  late HabitAIService aiService;

  @override
  void initState() {
    super.initState();

    analyzer = HabitAnalyzer(widget.habitService);
    aiService = HabitAIService();

    _loadAI();
  }

  Future<void> _loadAI() async {
    final analysis = await analyzer.analyze(widget.habit);

    setState((){
      
    })
  }
}