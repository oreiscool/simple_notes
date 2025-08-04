import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/data/notes_database.dart';

final notesDataBaseProvider = Provider<NotesDataBase>((ref) {
  return NotesDataBase();
});
