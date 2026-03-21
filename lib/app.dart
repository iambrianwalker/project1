//main app widget that manages theme state and provides it to the rest of the app
//the theme toggle feature is born here

import 'package:flutter/material.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class HabitMasteryApp extends StatelessWidget {
  final ThemeController themeController;

  const HabitMasteryApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Habits',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: MainShell(themeController: themeController),
        );
      },
    );
  }
}
