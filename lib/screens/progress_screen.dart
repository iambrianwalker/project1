//this screen will load habits and completion data
//and transform that into chart ready datasets
//the screen will show consistency, trends

import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/habit_completion.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_theme_extensions.dart';
import '../theme/app_spacing.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final HabitRepository _habitRepository = HabitRepository();
  final HabitCompletionRepository _completionRepository =
      HabitCompletionRepository();

  //a page controller to help build a chart carousel
  late final PageController _chartPageController;
  int _currentChartPage = 0;

  //a time range used to filter completions before computer chart data
  ProgressRange _selectedRange = ProgressRange.last7days;

  //loading flag while data is fetched and store error message if needed
  bool _isLoading = true;
  String? _errorMessage;

  //storage for habits and completions and custom ProgressSummary metrics
  List<Habit> _habits = [];
  List<HabitCompletion> _allCompletions = [];
  List<HabitCompletion> _recentCompletions = [];
  Map<int, List<HabitCompletion>> _completionMap = {};

  ProgressSummary? _summary;

  //storage for chart-ready data
  Map<DateTime, int> _heatmapData = {};
  List<HabitBreakdownPoint> _habitBreakdownSeries = [];
  List<DailyCompletionPoint> _dailyCompletionSeries = [];
  List<WeekdayCompletionPoint> _weekdayPatternSeries = [];

  //maybe some insights
  List<ProgressInsight> _insights = [];

  @override
  void initState() {
    super.initState();
    _chartPageController = PageController();
    _loadProgressData();
  }

  @override
  void dispose() {
    _chartPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _buildBody(),
    );
  }

  //this method will choose which state to show, loading, error, no habits, etc.
  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_hasNoHabits()) {
      return _buildNoHabitsState();
    }

    if (_hasNoCompletions()) {
      return _buildNoCompletionsState();
    }

    return RefreshIndicator(
      onRefresh: _loadProgressData,
      child: _buildContent(),
    );
  }

  //method to fetch data from the database for this screen
  Future<void> _loadProgressData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final habits = await _habitRepository.getAllHabits();
      final completionMap = <int, List<HabitCompletion>>{};
      final allCompletions = <HabitCompletion>[];

      for (final habit in habits) {
        if (habit.id == null) continue;

        final completions = await _completionRepository.getCompletionsForHabit(
          habit.id!,
        );
        completionMap[habit.id!] = completions;
        allCompletions.addAll(completions);
      }

      allCompletions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      if (!mounted) return;

      setState(() {
        _habits = habits;
        _completionMap = completionMap;
        _allCompletions = allCompletions;
        _recentCompletions = allCompletions.take(5).toList();
      });

      _rebuildDerivedData();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load the progress data: $error';
        _isLoading = false;
      });
    }
  }

  //this method will rebuild data after the selected date range changes
  void _rebuildDerivedData() {
    _calculateSummaryMetrics();

    if (!mounted) return;
    setState(() {});
  }

  //this method will build loading state while repository/service calls finish
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  //tis method will build the error staate and provide a retry action that calls
  //loadProgressData
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            AppSpacing.gapLg,
            Text(
              'Just some error, nothing to see here!',
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              _errorMessage ?? 'The progress data was not able to be loaded',
              style: context.text.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapLg,
            FilledButton.icon(
              onPressed: _loadProgressData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  //this method will build the empty state shown when the database has no habits yet
  Widget _buildNoHabitsState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insights_outlined, size: 48),
            AppSpacing.gapLg,
            Text(
              'No habits yet.',
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              'Create your first habit to start building progress data!',
              style: context.text.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //this method will handle when habits exist but they have no completions yet
  Widget _buildNoCompletionsState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.show_chart, size: 48),
            AppSpacing.gapLg,
            Text(
              'You have no completions yet.',
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              'Complete a habit to unlock charts and consistency tracking.',
              style: context.text.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //method to build the main scrollable progress content
  Widget _buildContent() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.screenPadding,
      children: [
        _buildHeaderSection(),
        AppSpacing.gapLg,
        _buildRangeSelector(),
        AppSpacing.gapLg,
        _buildSummarySection(),
        AppSpacing.gapXl,
        //_buildChartCarouselSection(),
        AppSpacing.gapLg,
        //##TODO could use some sections below the chart section
      ],
    );
  }

  //build the top section that explains the screens purpose
  Widget _buildHeaderSection() {
    final subtitle = switch (_selectedRange) {
      ProgressRange.last7days => 'Your consistency over the last 7 days',
      ProgressRange.last30days => 'Your consistency over the last 30 days.',
      ProgressRange.allTime => 'Your full completion history.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A peek at your progress',
          style: context.text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.gapSm,
        Text(
          subtitle,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  //build the date range selector
  Widget _buildRangeSelector() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: ProgressRange.values.map((range) {
        final isSelected = range == _selectedRange;
        return ChoiceChip(
          label: Text(range.label),
          selected: isSelected,
          onSelected: (_) => _onRangeChanged(range),
        );
      }).toList(),
    );
  }

  //build the summary metrics area
  Widget _buildSummarySection() {
    final summary = _summary;
    if (summary == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Activity Summary',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        AppSpacing.gapMd,
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              children: [
                _buildSummaryRow(
                  icon: Icons.check_circle_outline_rounded,
                  value: '${summary.completionsInRange}',
                  label: 'Completions in Range',
                  subtitle: _selectedRange.label,
                ),
                const Divider(),
                _buildSummaryRow(
                  icon: Icons.history_rounded,
                  value: '${summary.totalCompletions}',
                  label: 'Total Completions',
                  subtitle: 'All time',
                ),
                const Divider(),
                _buildSummaryRow(
                  icon: Icons.local_fire_department_rounded,
                  value: '${summary.activeHabits}',
                  label: 'Active Habits',
                  subtitle: 'Currently active',
                ),
                const Divider(),
                _buildSummaryRow(
                  icon: Icons.bolt_rounded,
                  value: '${summary.bestCurrentStreak}',
                  label: 'Best Streak',
                  subtitle: 'Current best',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //individual rows for the summary metrics
  Widget _buildSummaryRow({
    required IconData icon,
    required String value,
    required String label,
    String? subtitle,
  }) {
    return Padding(
      padding: AppSpacing.tilePadding,
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.primary),
          AppSpacing.gapSm,
          SizedBox(
            width: 28,
            child: Text(
              value,
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          AppSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //the chart carousel area widget
  Widget _buildChartCarouselSection() {
    throw UnimplementedError();
  }

  //actual PageView for the chart carousel
  Widget _buildChartCarousel() {
    throw UnimplementedError();
  }

  //chart card
  Widget _buildChartCard() {
    throw UnimplementedError();
  }

  //chart page indicator dots
  Widget _buildChartPageIndicator() {
    throw UnimplementedError();
  }

  //this method will return true when there are zero habits in storage
  bool _hasNoHabits() {
    return _habits.isEmpty;
  }

  //this method will return true when there are habits but no completions yet
  bool _hasNoCompletions() {
    return _allCompletions.isEmpty;
  }

  void _onRangeChanged(ProgressRange range) {
    if (range == _selectedRange) return;

    setState(() {
      _selectedRange = range;
    });

    _rebuildDerivedData();
  }

  Habit? _habitForId(int habitId) {
    for (final habit in _habits) {
      if (habit.id == habitId) return habit;
    }
    return null;
  }

  List<HabitCompletion> _getFilteredCompletions() {
    final all = List<HabitCompletion>.from(_allCompletions);

    if (_selectedRange == ProgressRange.allTime) {
      return all;
    }

    final now = DateTime.now();
    final start = switch (_selectedRange) {
      ProgressRange.last7days => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6)),
      ProgressRange.last30days => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 29)),
      ProgressRange.allTime => DateTime.fromMillisecondsSinceEpoch(0),
    };

    return all.where((completion) {
      final completedOn = DateUtils.dateOnly(completion.completedAt);
      return !completedOn.isBefore(start);
    }).toList();
  }

  void _calculateSummaryMetrics() {
    final filteredCompletions = _getFilteredCompletions();

    final totalCompletions = _allCompletions.length;
    final completionsInRange = filteredCompletions.length;
    final activeHabits = _habits.where((habit) => habit.isActive).length;
    final bestCurrentStreak = _habits.isEmpty
        ? 0
        : _habits.map((habit) => habit.currentStreak).fold<int>(0, math.max);

    String? topHabitName;
    if (_habitBreakdownSeries.isNotEmpty) {
      topHabitName = _habitBreakdownSeries.first.habitName;
    } else {
      final counts = <int, int>{};
      for (final completion in filteredCompletions) {
        counts.update(
          completion.habitId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      if (counts.isNotEmpty) {
        final sorted = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        topHabitName = _habitForId(sorted.first.key)?.habitName;
      }
    }

    _summary = ProgressSummary(
      totalCompletions: totalCompletions,
      completionsInRange: completionsInRange,
      activeHabits: activeHabits,
      bestCurrentStreak: bestCurrentStreak,
      topHabitName: topHabitName,
    );
  }
} //end of progress screen state class

//used for the currently selected progress date window
enum ProgressRange { last7days, last30days, allTime }

extension ProgressRangeExtension on ProgressRange {
  String get label {
    switch (this) {
      case ProgressRange.last7days:
        return '7D';
      case ProgressRange.last30days:
        return '30D';
      case ProgressRange.allTime:
        return 'All';
    }
  }
}

//little model to represent summary metrics
class ProgressSummary {
  final int totalCompletions;
  final int completionsInRange;
  final int activeHabits;
  final int bestCurrentStreak;

  //final int longestStreak;
  final String? topHabitName;

  const ProgressSummary({
    required this.totalCompletions,
    required this.completionsInRange,
    required this.activeHabits,
    required this.bestCurrentStreak,
    //required this.longestStreak,
    required this.topHabitName,
  });
}

//little model to represent one point in the daily completion trend
class DailyCompletionPoint {
  final DateTime date;
  final int count;

  const DailyCompletionPoint({required this.date, required this.count});
}

//model to represent one point in the habit breakdown chart
class HabitBreakdownPoint {
  final String habitName;
  final int count;

  const HabitBreakdownPoint({required this.habitName, required this.count});
}

//model to represent one point in the weekday pattern chart
class WeekdayCompletionPoint {
  final String weekdayLabel;
  final int count;

  const WeekdayCompletionPoint({
    required this.weekdayLabel,
    required this.count,
  });
}

//model to represent a short analytical takeaway displayed in the insights area
class ProgressInsight {
  final IconData icon;
  final String title;
  final String message;

  const ProgressInsight({
    required this.icon,
    required this.title,
    required this.message,
  });
}
