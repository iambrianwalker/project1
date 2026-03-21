//the main shell of the app with bottom bar navigation
//to switch between main screens: Dashboard, Habits, Progress, and Settings

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final screens = [
      DashboardScreen(),
      HabitsScreen(),
      ProgressScreen(),
      SettingsScreen(themeController: widget.themeController),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
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
