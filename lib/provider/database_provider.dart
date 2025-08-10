import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/data/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() async {
    await database.close();
  });
  return database;
});

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllNotes();
});

final searchNotesProvider = FutureProvider.family<List<Note>, String>((
  ref,
  query,
) {
  if (query.trim().isEmpty) {
    return Future.value(<Note>[]);
  }
  final database = ref.watch(databaseProvider);
  return database.searchNotes(query.trim());
});
