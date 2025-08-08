import 'package:flutter/material.dart';
import 'package:simple_notes/data/database_service.dart';
import 'package:simple_notes/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: themeMode,
    );
  }
}
