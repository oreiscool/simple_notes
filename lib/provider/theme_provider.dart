import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/provider/database_provider.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadInitialTheme();
    return ThemeMode.system;
  }

  Future<void> _loadInitialTheme() async {
    try {
      final database = ref.read(databaseProvider);
      final isDarkMode = await database.isDarkMode();
      state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final currentIsDark = state == ThemeMode.dark;
    final newThemeMode = currentIsDark ? ThemeMode.light : ThemeMode.dark;

    try {
      final database = ref.read(databaseProvider);
      state = newThemeMode;
      await database.setDarkMode(!currentIsDark);
    } catch (e) {
      state = currentIsDark ? ThemeMode.dark : ThemeMode.light;
      rethrow;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    try {
      final database = ref.read(databaseProvider);
      state = mode;
      if (mode != ThemeMode.system) {
        await database.setDarkMode(mode == ThemeMode.dark);
      }
    } catch (e) {
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      rethrow;
    }
  }
}

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});
