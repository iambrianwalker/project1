//this screen will load habits and completion data
//and transform that into chart ready datasets
//the screen will show consistency, trends

import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:chartify/chartify.dart';
import 'package:habit_mastery/theme/app_corners.dart';
import '../models/habit_model.dart';
import '../models/habit_completion.dart';
import '../repositories/habit_repository.dart';
import '../repositories/habit_completion_repository.dart';
import '../theme/app_theme_extensions.dart';
import '../theme/app_spacing.dart';
import '../theme/chart_palette.dart';

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
  List<DailyCompletionPoint> _dailyCompletionSeries = [];

  //storage for chart-ready data
  // List<HabitBreakdownPoint> _habitBreakdownSeries = [];
  // List<WeekdayCompletionPoint> _weekdayPatternSeries = [];

  //maybe some insights
  // List<ProgressInsight> _insights = [];

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
    _buildDailyCompletionSeries();
    _buildHeatmapData();
    _calculateSummaryMetrics();

    if (!mounted) return;
    setState(() {});
  }

  //this method will build loading state while repository/service calls finish
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: context.appColors.brand),
    );
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
            Icon(
              Icons.error_outline,
              size: 48,
              color: context.appColors.warning,
            ),
            AppSpacing.gapLg,
            Text(
              'Just some error, nothing to see here!',
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              _errorMessage ?? 'The progress data was not able to be loaded',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
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
            Icon(
              Icons.insights_outlined,
              size: 48,
              color: context.appColors.brand,
            ),
            AppSpacing.gapLg,
            Text(
              'No habits yet.',
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              'Create your first habit to start building progress data!',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
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
            Icon(Icons.show_chart, size: 48, color: context.appColors.chart1),
            AppSpacing.gapLg,
            Text(
              'You have no completions yet.',
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              'Complete a habit to unlock charts and consistency tracking.',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
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
        _buildChartCarouselSection(),
        AppSpacing.gapLg,
        _buildRecentActivitySection(),
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
          child: Container(
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(AppCorners.lg),
              border: Border.all(color: context.appColors.cardBorder),
            ),
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
                  Divider(color: context.appColors.cardBorder, height: 1),
                  _buildSummaryRow(
                    icon: Icons.history_rounded,
                    value: '${summary.totalCompletions}',
                    label: 'Total Completions',
                    subtitle: 'All time',
                  ),
                  Divider(color: context.appColors.cardBorder, height: 1),
                  _buildSummaryRow(
                    icon: Icons.local_fire_department_rounded,
                    value: '${summary.activeHabits}',
                    label: 'Active Habits',
                    subtitle: 'Currently active',
                  ),
                  Divider(color: context.appColors.cardBorder, height: 1),
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
        ),
      ],
    );
  }

  //individual rows for the summary metrics
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
          Icon(icon, size: 20, color: context.appColors.brand),
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
          AppSpacing.gapMd,
          Text(
            value,
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  //the chart carousel area widget
  Widget _buildChartCarouselSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Charts',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        AppSpacing.gapMd,
        SizedBox(height: 360, child: _buildChartCarousel()),
        AppSpacing.gapMd,
        Center(child: _buildChartPageIndicator()),
      ],
    );
  }

  //actual PageView for the chart carousel
  Widget _buildChartCarousel() {
    return ScrollConfiguration(
      behavior: MaterialScrollBehavior().copyWith(
        dragDevices: const {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      child: PageView(
        controller: _chartPageController,
        onPageChanged: (index) {
          setState(() {
            _currentChartPage = index;
          });
        },
        children: [
          _buildChartCard(
            title: 'Completion Trend',
            subtitle: 'Your completions across time',
            child: _buildCompletionTrendChart(),
          ),
          _buildChartCard(
            title: 'Consistency Heatmap',
            subtitle: 'Days you got it done',
            child: _buildConsistencyHeatmap(),
          ),
        ],
      ),
    );
  }

  //chart card
  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: BorderRadius.circular(AppCorners.lg),
          border: Border.all(color: context.appColors.cardBorder),
        ),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapXs,
              Text(
                subtitle,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapMd,
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  //chart page indicator dots
  Widget _buildChartPageIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2, (index) {
        final isActive = index == _currentChartPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? context.appColors.brand
                : context.colors.outline.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppCorners.pill),
          ),
        );
      }),
    );
  }

  //this method will build a line chart using chartify
  Widget _buildCompletionTrendChart() {
    if (_dailyCompletionSeries.isEmpty) {
      return Center(
        child: Text(
          'No completion data in this range yet.',
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      );
    }

    final chartColors = ChartPalette.chartColors(context);
    final lineColor = chartColors.first;

    final points = List.generate(_dailyCompletionSeries.length, (index) {
      final item = _dailyCompletionSeries[index];
      return DataPoint<int, double>(x: index, y: item.count.toDouble());
    });

    final maxCount = _dailyCompletionSeries
        .map((e) => e.count)
        .fold<int>(0, math.max);

    final yMax = math.max(1, maxCount).toDouble();
    final width = MediaQuery.sizeOf(context).width;
    final labelStep = switch (_selectedRange) {
      ProgressRange.last7days => width < 420 ? 3 : 2,
      ProgressRange.last30days => width < 420 ? 10 : 7,
      ProgressRange.allTime => math.max(
        1,
        (_dailyCompletionSeries.length / 6).ceil(),
      ),
    };

    return LineChart(
      data: LineChartData(
        series: [
          LineSeries<int, double>(
            name: 'Completions',
            data: points,
            color: lineColor,
            strokeWidth: 3,
            curved: false,
            showMarkers: true,
            markerSize: 6,
            fillArea: true,
            areaOpacity: 0.10,
          ),
        ],
        xAxis: AxisConfig(
          label: 'Day',
          labelFormatter: (value) {
            final index = value.toInt();
            if (index < 0 || index >= _dailyCompletionSeries.length) return '';

            if (index != 0 &&
                index != _dailyCompletionSeries.length - 1 &&
                index % labelStep != 0) {
              return '';
            }

            final point = _dailyCompletionSeries[index];
            return '${point.date.month}/${point.date.day}';
          },
        ),
        yAxis: AxisConfig(
          label: 'Completions',
          min: 0,
          max: yMax,
          labelFormatter: (value) {
            if (value % 1 != 0) return '';
            return value.toInt().toString();
          },
        ),
      ),
      tooltip: const TooltipConfig(
        enabled: true,
        showIndicatorLine: true,
        showIndicatorDot: true,
      ),
      showCrosshair: true,
      animation: const ChartAnimation(
        duration: Duration(milliseconds: 800),
        type: AnimationType.draw,
      ),
    );
  }

  //this method will build a heatMap using chartify
  Widget _buildConsistencyHeatmap() {
    if (_heatmapData.isEmpty) {
      return Center(
        child: Text(
          'No heatmap data in this range yet.',
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      );
    }

    final heatColors = ChartPalette.heatmapColors(context);
    final data =
        _heatmapData.entries
            .map(
              (entry) => CalendarDataPoint(
                date: entry.key,
                value: entry.value.toDouble(),
              ),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    final sortedDates = data.map((e) => e.date).toList();
    final start = sortedDates.first;
    final end = sortedDates.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16,
              color: context.appColors.badge,
            ),
            const SizedBox(width: 6),
            Text(
              '${_formatMonthDay(start)} - ${_formatMonthDay(end)}',
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildHeatmapWeekdayHeader(),
        const SizedBox(height: 8),
        Expanded(
          child: CalendarHeatmapChart(
            data: CalendarHeatmapData(
              data: data,
              colorStops: heatColors,
              cellSize: _selectedRange == ProgressRange.last30days ? 10 : 12,
              cellSpacing: 3,
              cellRadius: 3,
              showDayLabels: false,
              showMonthLabels: false,
            ),
            tooltip: const TooltipConfig(enabled: true),
            animation: const ChartAnimation(
              duration: Duration(milliseconds: 900),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildHeatmapLegend(heatColors),
      ],
    );
  }

  //this method will provide the single letter day of the week for the heatMap header
  Widget _buildHeatmapWeekdayHeader() {
    final style = context.text.labelSmall?.copyWith(
      color: context.colors.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('S', style: style),
          Text('M', style: style),
          Text('T', style: style),
          Text('W', style: style),
          Text('T', style: style),
          Text('F', style: style),
          Text('S', style: style),
        ],
      ),
    );
  }

  //this method provides the heatMap with the legend just below the heatMap itself
  Widget _buildHeatmapLegend(List<Color> heatColors) {
    return Row(
      children: [
        Text(
          'Less',
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(heatColors.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == heatColors.length - 1 ? 0 : 4,
            ),
            child: _buildHeatLegendSwatch(heatColors[index]),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'More',
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  //this method build the individual colors with decorations and borders on the legend
  Widget _buildHeatLegendSwatch(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppCorners.sm),
        border: Border.all(color: context.appColors.cardBorder),
      ),
    );
  }

  //this method provides the screen with the recent activity section
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Completions',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        AppSpacing.gapMd,
        Card(
          child: Container(
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(AppCorners.lg),
              border: Border.all(color: context.appColors.cardBorder),
            ),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: _recentCompletions.isEmpty
                  ? Text(
                      'No recent completions yet.',
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    )
                  : Column(
                      children: List.generate(_recentCompletions.length, (
                        index,
                      ) {
                        final completion = _recentCompletions[index];
                        final habit = _habitForId(completion.habitId);
                        final isLast = index == _recentCompletions.length - 1;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 18,
                                  color: context.appColors.success,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    habit?.habitName ?? 'Unknown habit',
                                    style: context.text.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatCompletionTimestamp(
                                    completion.completedAt,
                                  ),
                                  style: context.text.bodySmall?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            if (!isLast) ...[
                              const SizedBox(height: 12),
                              Divider(
                                color: context.appColors.cardBorder,
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  //helper method to provide heatmap with abrr for month
  String _formatMonthDay(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month]} ${date.day}';
  }

  //helper method for recent activity screen
  String _formatCompletionTimestamp(DateTime dateTime) {
    final date = DateUtils.dateOnly(dateTime);
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final meridiem = dateTime.hour >= 12 ? 'PM' : 'AM';
    final timeLabel = '$hour:$minute $meridiem';

    if (date == today) return 'Today • $timeLabel';
    if (date == yesterday) return 'Yesterday • $timeLabel';

    return '${_formatMonthDay(date)} • $timeLabel';
  }

  DateTime _rangeStartForChart() {
    final now = DateUtils.dateOnly(DateTime.now());

    switch (_selectedRange) {
      case ProgressRange.last7days:
        return now.subtract(const Duration(days: 6));
      case ProgressRange.last30days:
        return now.subtract(const Duration(days: 29));
      case ProgressRange.allTime:
        if (_allCompletions.isEmpty) return now;
        return _allCompletions
            .map((completion) => DateUtils.dateOnly(completion.completedAt))
            .reduce((a, b) => a.isBefore(b) ? a : b);
    }
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

  void _buildDailyCompletionSeries() {
    final filtered = _getFilteredCompletions();
    final counts = <DateTime, int>{};

    for (final completion in filtered) {
      final date = DateUtils.dateOnly(completion.completedAt);
      counts.update(date, (value) => value + 1, ifAbsent: () => 1);
    }

    final start = _rangeStartForChart();
    final end = DateUtils.dateOnly(DateTime.now());

    final points = <DailyCompletionPoint>[];
    var current = start;

    while (!current.isAfter(end)) {
      points.add(
        DailyCompletionPoint(date: current, count: counts[current] ?? 0),
      );
      current = current.add(const Duration(days: 1));
    }

    _dailyCompletionSeries = points;
  }

  void _buildHeatmapData() {
    final filtered = _getFilteredCompletions();
    final data = <DateTime, int>{};

    for (final completion in filtered) {
      final date = DateUtils.dateOnly(completion.completedAt);
      data.update(date, (value) => value + 1, ifAbsent: () => 1);
    }

    _heatmapData = data;
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
    if (filteredCompletions.isNotEmpty) {
      final counts = <int, int>{};
      for (final completion in filteredCompletions) {
        counts.update(
          completion.habitId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      final sorted = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topHabitName = _habitForId(sorted.first.key)?.habitName;
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
