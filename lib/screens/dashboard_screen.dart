import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_mastery/models/habit_completion.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../services/habit_ai_service.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';
import '../widgets/habit_ai_card.dart';


class DashboardScreen extends StatefulWidget{
  final HabitService habitService;

  const DashboardScreen({super.key, required this.habitService});

  @override
  State<DashboardScreen> createtate() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List> _activeHabitsFuture;
  late Future<int> _completedTodayFuture;
  late Future<int> _longestStreakFuture;
  String? _aiBuddyMessage;
  List<HabitCompletion> _recentActivity = [];
  Map<String, bool> _weeklyProgress = {};

  @override
  void initState(){
    super.initState();
    _loadDashboardData();
  }
}