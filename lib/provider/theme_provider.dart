import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final Box _settingsBox = Hive.box("settingsBox");
  final String _darkModeKey = "isDarkMode";

  ThemeNotifier() : super(ThemeMode.dark) {
    _loadThemeFromBox();
  }

  void _loadThemeFromBox() {
    final bool isDarkMode = _settingsBox.get(_darkModeKey, defaultValue: true);
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveThemeToBox(bool isDarkMode) {
    _settingsBox.put(_darkModeKey, isDarkMode);
  }

  void toggleTheme() {
    final newIsDarkMode = state == ThemeMode.light;
    _saveThemeToBox(newIsDarkMode);
    state = newIsDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
