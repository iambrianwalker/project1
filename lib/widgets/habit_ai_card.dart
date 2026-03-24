import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../services/habit_analyzer.dart';
import '../services/habit_ai_service.dart';
import '../theme/app_spacing.dart';

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
      message = aiService.generateMessage(widget.habit, analysis);
      goal = aiService.generateMicroGoal(widget.habit, analysis);
      isLoading = false;
    });
  }

  Future<void> _completeHabit() async {
    final result = await widget.habitService.completeHabit(widget.habit);

    if (result.success) {
      await _loadAI(); //refreshes AI after completion
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message)),
    );
  }

  @override
  Widget  build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text("Loading..."),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Habit Name
            Text(
              widget.habit.habitName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            AppSpacing.gapSm,

            //AI Message
            Text(
              message ?? '',
              style: const TextStyle(fontSize: 14),
            ),

            AppSpacing.gapSm,

            //Micro goal
            Text(
              "$goal",
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),

            AppSpacing.gapMd,

            //Complete button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _completeHabit,
                child: const Text('Complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}