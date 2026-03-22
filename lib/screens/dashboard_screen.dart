import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../services/habit_ai_service.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';
import '../widgets/habit_ai_card.dart';


class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  late HabitService habitService;
  late HabitAIService aiService;

  List<Habit> habits = [];
  bool isLoading = true;
  String aiMessage = "";

  @override
  void initState(){
    super.initState();
    
  }
}