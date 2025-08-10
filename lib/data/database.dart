import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

@DataClassName('Note')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get lastModified => dateTime()();
}

@DataClassName('AppSetting')
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isDarkMode => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Notes, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'notes.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  Future<List<Note>> getAllNotes() => select(notes).get();
  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  Future<int> createNote(String title, String content) {
    return into(notes).insert(
      NotesCompanion.insert(
        title: title,
        content: content,
        lastModified: DateTime.now(),
      ),
    );
  }

  Future<bool> updateNote(Note note) => update(notes).replace(note);

  Future<int> deleteNote(int id) =>
      (delete(notes)..where((n) => n.id.equals(id))).go();

  Future<List<Note>> searchNotes(String query) {
    return (select(
      notes,
    )..where((n) => n.title.contains(query) | n.content.contains(query))).get();
  }

  Future<bool> isDarkMode() async {
    final setting = await (select(settings)).getSingleOrNull();
    return setting?.isDarkMode ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final existing = await (select(settings)).getSingleOrNull();
    if (existing == null) {
      await into(
        settings,
      ).insert(SettingsCompanion.insert(isDarkMode: Value(value)));
    } else {
      await update(settings).replace(existing.copyWith(isDarkMode: value));
    }
  }
}
