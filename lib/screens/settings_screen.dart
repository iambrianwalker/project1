import 'package:flutter/material.dart';
import 'package:habit_mastery/theme/app_theme_extensions.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController;

  const SettingsScreen({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        final theme = context.theme;
        final scheme = context.colors;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Text(
                'Appearance',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                'Choose how Habit Mastery looks across the app.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapXl,

              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: const Text('Quick toggle dark mode'),
                  subtitle: const Text('Switch between light and dark'),
                  value: themeController.isDark,
                  onChanged: (_) => themeController.toggleTheme(),
                ),
              ),

              AppSpacing.gapMd,

              Card(
                child: Column(
                  children: [
                    RadioGroup<ThemeMode>(
                      groupValue: themeController.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeController.setTheme(value);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.system,
                            title: const Text('System'),
                            subtitle: const Text('Match device appearance'),
                            secondary: const Icon(Icons.phone_android_rounded),
                          ),
                          Divider(height: 1),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.light,
                            title: const Text('Light'),
                            subtitle: const Text('Bright workspace style'),
                            secondary: const Icon(Icons.light_mode_rounded),
                          ),
                          Divider(height: 1),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.dark,
                            title: const Text('Dark'),
                            subtitle: const Text('Low-light focused style'),
                            secondary: const Icon(Icons.dark_mode_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
