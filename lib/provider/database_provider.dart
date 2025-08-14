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

final singleNoteProvider = StreamProvider.family<NoteModel?, int>((ref, id) {
  final database = ref.watch(databaseProvider);
  final rawNoteStream = database.watchSingleNote(id);
  return rawNoteStream.map((rawNote) {
    if (rawNote == null) return null;
    return NoteModel.fromDatabase(rawNote);
  });
});

class SearchQueryNotfier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotfier, String>(() {
  return SearchQueryNotfier();
});

final searchNotesProvider = FutureProvider<List<NoteModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return [];
  }
  await Future.delayed(const Duration(milliseconds: 500));
  final database = ref.watch(databaseProvider);
  final rawNotesList = await database.searchNotes(query.trim());
  return [for (final rawNote in rawNotesList) NoteModel.fromDatabase(rawNote)];
});
