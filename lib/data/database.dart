import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_notes/models/notemodel.dart';

class NotesDataBase {
  List<Note> notesList = [];

  final _notesBox = Hive.box('notesBox');

  void loadData() {
    notesList = List<Note>.from(_notesBox.get("NOTES", defaultValue: []));
  }

  void updateData() {
    _notesBox.put("NOTES", notesList);
  }

  void deleteNote(int index) {
    notesList.removeAt(index);
    updateData();
  }
}
