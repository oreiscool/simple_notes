import 'package:simple_notes/models/note_model.dart';

abstract class NoteRepository {
  Stream<List<NoteModel>> watchAllNotes();
  Future<List<NoteModel>> searchNotes(String query);
  Future<NoteModel> createNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(int id);
  Future<NoteModel?> getNoteById(int id);
}
