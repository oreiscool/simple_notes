import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/settings_model.dart';
import 'package:simple_notes/provider/database_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsModel>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    _loadInitialSettings();
    return const SettingsModel(isDarkMode: false, isAutoSaveEnabled: true);
  }

  Future<void> _loadInitialSettings() async {
    try {
      final database = ref.read(databaseProvider);
      final isDarkMode = await database.isDarkMode();
      final isAutoSaveEnabled = await database.isAutoSaveEnabled();
      state = SettingsModel(
        isDarkMode: isDarkMode,
        isAutoSaveEnabled: isAutoSaveEnabled,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTheme() async {
    try {
      state = state.copyWith(isDarkMode: !state.isDarkMode);
      await ref.read(databaseProvider).setDarkMode(state.isDarkMode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleAutoSave() async {
    try {
      state = state.copyWith(isAutoSaveEnabled: !state.isAutoSaveEnabled);
      await ref
          .read(databaseProvider)
          .setAutoSaveEnabled(state.isAutoSaveEnabled);
    } catch (e) {
      rethrow;
    }
  }
}

final themeProvider = Provider<ThemeMode>((ref) {
  final isDark = ref.watch(settingsProvider).isDarkMode;
  return isDark ? ThemeMode.dark : ThemeMode.light;
});

final autoSaveProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isAutoSaveEnabled;
});
