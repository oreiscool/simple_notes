import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/data/database_service.dart';
import 'package:simple_notes/models/note_model.dart';

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final dbService = ref.watch(databaseProvider);
  return dbService.listenToNotes();
});
