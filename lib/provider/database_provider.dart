import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/data/database.dart';
import 'package:simple_notes/models/note_model.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() async {
    await database.close();
  });
  return database;
});

final notesStreamProvider = StreamProvider<List<NoteModel>>((ref) {
  final database = ref.watch(databaseProvider);
  final rawNotesStream = database.watchAllNotes();
  return rawNotesStream.map((listOfRawNotes) {
    return [
      for (final rawNote in listOfRawNotes) NoteModel.fromDatabase(rawNote),
    ];
  });
});

final searchNotesProvider = FutureProvider.family<List<NoteModel>, String>((
  ref,
  query,
) async {
  if (query.trim().isEmpty) {
    return Future.value(<NoteModel>[]);
  }
  final database = ref.watch(databaseProvider);
  final rawNotesList = await database.searchNotes(query.trim());
  return [for (final rawNote in rawNotesList) NoteModel.fromDatabase(rawNote)];
});
