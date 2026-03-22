//the main shell of the app with bottom bar navigation
//to switch between main screens: Dashboard, Habits, Progress, and Settings

import 'package:flutter/material.dart';
import 'package:habit_mastery/repositories/habit_completion_repository.dart';
import 'package:habit_mastery/repositories/habit_repository.dart';
import 'package:habit_mastery/services/habit_service.dart';
import 'package:habit_mastery/theme/app_theme_extensions.dart';
import '../theme/theme_controller.dart';
import 'dashboard_screen.dart';
import 'habits_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  final ThemeController themeController;

  const MainShell({super.key, required this.themeController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final HabitRepository _habitRepository;
  late final HabitCompletionRepository _completionRepository;
  late final HabitService _habitService;

  late final List<Widget> _screens;

  @override
  void initState(){
    super.initState();

    _habitRepository = HabitRepository();
    _completionRepository = HabitCompletionRepository();

    _habitService = HabitService(
      habitRepository: _habitRepository, 
      completionRepository: _completionRepository
    );

    _screens = [
      DashboardScreen(
        habitRepository: _habitRepository, 
        habitService: _habitService
      ),
      HabitsScreen(),
      ProgressScreen(),
      SettingsScreen(themeController: widget.themeController),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: appColors.navBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }, //end on tap
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ], //end items
        ),
      ),
    ); //end Scaffold
  } //end build
} //end _MainShellState
