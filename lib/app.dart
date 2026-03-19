//main app widget that manages theme state and provides it to the rest of the app
//the theme toggle feature is born here

import 'package:flutter/material.dart';
import 'screens/main_shell.dart';

class HabitMasteryApp extends StatefulWidget {
  const HabitMasteryApp({super.key});

  @override
  State<HabitMasteryApp> createState() => _HabitMasteryAppState();
}

class _HabitMasteryAppState extends State<HabitMasteryApp> {
  //track theme state, default to dark mode
  bool _isDark = true;

  //toggle theme mode and rebuild app
  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    //define light theme using Material 3 color scheme
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey.shade300,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.black,
        surface: Colors.grey.shade200,
        onSurface: Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
      ),
      useMaterial3: true,
    );

    //define dark theme using Material 3 color scheme
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        surface: Colors.blueGrey.shade800,
        onSurface: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueGrey.shade800,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      useMaterial3: true,
    );

    //return MaterialApp with theme and home screen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Mastery',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: MainShell(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}