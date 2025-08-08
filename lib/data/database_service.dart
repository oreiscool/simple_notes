import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:isar/isar.dart';
import 'package:simple_notes/models/settings_model.dart';

class DatabaseService {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    DatabaseService.isar = await Isar.open([
      NoteSchema,
      SettingsSchema,
    ], directory: dir.path);
  }

  Future<void> createNote(Note note) async {
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  Stream<List<Note>> listenToNotes() {
    return isar.notes.where().watch(fireImmediately: true);
  }

  Future<void> updateNote(Note note) async {
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }

  Future<List<Note>> searchNotes(String query) async {
    return await isar.notes
        .filter()
        .titleContains(query)
        .or()
        .contentContains(query)
        .findAll();
  }

  Future<void> saveThemeSetting(bool isDarkMode) async {
    await isar.writeTxn(() async {
      var settings = await isar.settings.get(0);
      settings ??= Settings();
      settings.isDarkMode = isDarkMode;
      await isar.settings.put(settings);
    });
  }

  Future<bool> readThemeSetting() async {
    final settings = await isar.settings.get(0);
    return settings?.isDarkMode ?? true;
  }
}
