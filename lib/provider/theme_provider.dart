import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/provider/database_provider.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;
  ThemeNotifier(this._ref) : super(ThemeMode.dark) {
    _loadInitialTheme();
  }

  Future<void> _loadInitialTheme() async {
    final db = _ref.read(databaseProvider);
    final isDarkMode = await db.readThemeSetting();
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final db = _ref.read(databaseProvider);
    final newIsDarkMode = state == ThemeMode.light;
    state = newIsDarkMode ? ThemeMode.dark : ThemeMode.light;
    await db.saveThemeSetting(newIsDarkMode);
  }
}
