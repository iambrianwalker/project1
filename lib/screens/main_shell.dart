//the main shell of the app with bottom bar navigation
//to switch between main screens: Dashboard, Habits, Progress, and Settings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'habits_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(),
      HabitsScreen(),
      ProgressScreen(),
      SettingsScreen(
          isDark: widget.isDark,
          onToggleTheme: widget.onToggleTheme,
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },//end on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.check_mark_circled),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_alt_fill),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ]//end items
      ),//end BottomNavigationBar
    );//end Scaffold
  }//end build
}//end _MainShellState