import 'package:drift/drift.dart';
import 'package:simple_notes/data/database.dart';

class SettingsModel {
  final bool isDarkMode;
  final String defaultNoteTitle;
  final bool isAutoSaveEnabled;
  final int autoSaveInterval;

  const SettingsModel({
    this.isDarkMode = false,
    this.defaultNoteTitle = 'New Note',
    this.isAutoSaveEnabled = true,
    this.autoSaveInterval = 2,
  });

  factory SettingsModel.fromDatabase(AppSetting dbSetting) {
    return SettingsModel(isDarkMode: dbSetting.isDarkMode);
  }

  SettingsCompanion toDatabaseCompanion() {
    return SettingsCompanion(isDarkMode: Value(isDarkMode));
  }

  AppSetting toDatabaseSetting(int id) {
    return AppSetting(id: id, isDarkMode: isDarkMode);
  }

  SettingsModel copyWith({
    bool? isDarkMode,
    String? defaultNoteTitle,
    bool? isAutoSaveEnabled,
    int? autoSaveInterval,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      defaultNoteTitle: defaultNoteTitle ?? this.defaultNoteTitle,
      isAutoSaveEnabled: isAutoSaveEnabled ?? this.isAutoSaveEnabled,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
    );
  }

  @override
  String toString() => 'SettingsModel(isDarkMode: $isDarkMode)';
}
