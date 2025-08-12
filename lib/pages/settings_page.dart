import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/provider/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final isAutoSaveEnabled = ref.watch(autoSaveProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleTheme();
            },
          ),
          SwitchListTile(
            title: Text('Auto Save'),
            value: isAutoSaveEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleAutoSave();
            },
          ),
        ],
      ),
    );
  }
}
