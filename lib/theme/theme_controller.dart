import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoaded = false;

  ThemeMode get themeMode => _themeMode;

  bool get isLoaded => _isLoaded;

  bool get isDark => _themeMode == ThemeMode.dark;

  bool get isLight => _themeMode == ThemeMode.light;

  bool get isSystem => _themeMode == ThemeMode.system;

  Future<void> loadTheme() async {
    final savedTheme = await _prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.system;
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_themeKey, _themeMode.name);
  }

  Future<void> toggleTheme() async {
    await setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
