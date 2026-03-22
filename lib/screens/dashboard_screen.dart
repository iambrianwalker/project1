import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../services/habit_ai_service.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_spacing.dart';


class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Dashboard'),
    );
  }
}