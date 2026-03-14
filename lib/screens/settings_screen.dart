import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: isDark,
          onChanged: (_) => onToggleTheme(),
          secondary: const Icon(Icons.dark_mode),
        ),
      ],
    );
  }
}