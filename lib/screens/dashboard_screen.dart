import 'package:flutter/material.dart';
import 'package:habit_mastery/models/habit_completion.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import '../services/habit_service.dart';
import '../services/habit_ai_service.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extensions.dart';
import '../widgets/habit_ai_card.dart';


class DashboardScreen extends StatefulWidget{
  final HabitRepository habitRepository;
  final HabitService habitService;

  const DashboardScreen({
    super.key, 
    required this.habitRepository,
    required this.habitService,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Habit>> _activeHabitsFuture;
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

  Future<void> _loadDashboardData() async {
    //Active Habits
    _activeHabitsFuture = widget.habitRepository.getActiveHabits(); 
  }

  int _completedToday(List<Habit> habits) {
    final now = DateTime.now();
    int count = 0;
    for (var habit in habits) {
      if (habit.lastCompletedAt != null &&
      habit.lastCompletedAt!.year == now.year &&
      habit.lastCompletedAt!.month == now.month &&
      habit.lastCompletedAt!.day == now.day) {
        count++;
      }
    }
    return count;
  }

  int _longestStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: SingleChildScrollView(
        child: FutureBuilder<List<Habit>>(
          future: _activeHabitsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final habits = snapshot.data!;

            final completedToday = _completedToday(habits);
            final longestStreak = _longestStreak(habits);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Greeting / Motivational Text
                Text(
                  "Good ${_greeting()}, let's crush some habits today!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                AppSpacing.gapLg,
                //Active Habits Section
                Text(
                  "Active Habits",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppSpacing.gapSm,
                if (habits.isEmpty)
                  Text("No active habits yet.", style: context.text.bodyMedium),
                ...habits.map((habit) => HabitAICard(
                  habit: habit,
                  habitService: widget.habitService,
                )),

                AppSpacing.gapLg,

                //Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard("Completed Today", "$completedToday"),
                    _statCard("Longest Streak", "$longestStreak"),
                  ],
                ),
                AppSpacing.gapLg,

                //Weekly Progress Placeholder
                _sectionTitle("Weekly Progress"),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Text("Weekly Progress Chart Here?")),
                ),
                AppSpacing.gapLg,
                
                //AI Buddy Message
                _sectionTitle("AI Buddy"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "",
                    style: context.text.bodyMedium,
                  ),
                ),
                AppSpacing.gapLg,

                //Recent Activity Placeholder
                _sectionTitle("Recent Activity"),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color:Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Text("Recent Completions, Streaks, etc")),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  String _greeting(){
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.text.bodyMedium),
            AppSpacing.gapSm,
            Text(value, style: context.text.headlineSmall),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: context.text.titleMedium),
    );
  }
}