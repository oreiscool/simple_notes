import 'package:simple_notes/models/settings_model.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings(SettingsModel settings);
  Future<void> watchSettings();
}
