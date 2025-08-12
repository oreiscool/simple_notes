import 'package:drift/drift.dart';
import 'package:simple_notes/data/database.dart';

class SettingsModel {
  final bool isDarkMode;
  final bool isAutoSaveEnabled;

  const SettingsModel({this.isDarkMode = false, this.isAutoSaveEnabled = true});

  factory SettingsModel.fromDatabase(AppSetting dbSetting) {
    return SettingsModel(
      isDarkMode: dbSetting.isDarkMode,
      isAutoSaveEnabled: dbSetting.isAutoSaveEnabled,
    );
  }

  SettingsCompanion toDatabaseCompanion() {
    return SettingsCompanion(
      isDarkMode: Value(isDarkMode),
      isAutoSaveEnabled: Value(isAutoSaveEnabled),
    );
  }

  AppSetting toDatabaseSetting(int id) {
    return AppSetting(
      id: id,
      isDarkMode: isDarkMode,
      isAutoSaveEnabled: isAutoSaveEnabled,
    );
  }

  SettingsModel copyWith({bool? isDarkMode, bool? isAutoSaveEnabled}) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isAutoSaveEnabled: isAutoSaveEnabled ?? this.isAutoSaveEnabled,
    );
  }

  @override
  String toString() =>
      'SettingsModel(isDarkMode: $isDarkMode, isAutoSaveEnabled: $isAutoSaveEnabled)';
}
