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
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
}

@DataClassName('AppSetting')
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isDarkMode => boolean().withDefault(const Constant(false))();
  BoolColumn get isAutoSaveEnabled =>
      boolean().withDefault(const Constant(true))();
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

  Future<List<Note>> getAllNotes() async {
    return (select(notes)..orderBy([
          (n) =>
              OrderingTerm(expression: notes.isPinned, mode: OrderingMode.desc),
          (n) => OrderingTerm(
            expression: notes.lastModified,
            mode: OrderingMode.desc,
          ),
        ]))
        .get();
  }

  Stream<List<Note>> watchAllNotes() {
    return (select(notes)..orderBy([
          (n) =>
              OrderingTerm(expression: notes.isPinned, mode: OrderingMode.desc),
          (n) => OrderingTerm(
            expression: notes.lastModified,
            mode: OrderingMode.desc,
          ),
        ]))
        .watch();
  }

  Stream<Note?> watchSingleNote(int id) {
    return (select(notes)..where((n) => n.id.equals(id))).watchSingleOrNull();
  }

  Future<int> createNote({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    try {
      return await into(notes).insert(
        NotesCompanion.insert(
          title: title,
          content: content,
          lastModified: DateTime.now(),
          isPinned: Value(isPinned),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateNote({
    required int id,
    required String title,
    required String content,
    bool? isPinned,
  }) async {
    try {
      final rowsAffected = await (update(notes)..where((n) => n.id.equals(id)))
          .write(
            NotesCompanion(
              title: Value(title),
              content: Value(content),
              lastModified: Value(DateTime.now()),
              isPinned: isPinned != null
                  ? Value(isPinned)
                  : const Value.absent(),
            ),
          );
      return rowsAffected > 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteNote(int id) async {
    try {
      final rowsDeleted = await (delete(
        notes,
      )..where((n) => n.id.equals(id))).go();
      return rowsDeleted > 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    try {
      return await (select(notes)
            ..where((n) => n.title.contains(query) | n.content.contains(query))
            ..orderBy([
              (n) =>
                  OrderingTerm(expression: n.isPinned, mode: OrderingMode.desc),
              (n) => OrderingTerm(
                expression: n.lastModified,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> toggleNotePin(int id) async {
    try {
      final note = await (select(
        notes,
      )..where((n) => n.id.equals(id))).getSingleOrNull();
      if (note == null) return false;
      final newPinStatus = !note.isPinned;
      return await updateNote(
        id: id,
        title: note.title,
        content: note.content,
        isPinned: newPinStatus,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAutoSaveEnabled() async {
    try {
      final setting = await (select(settings)).getSingleOrNull();
      return setting?.isAutoSaveEnabled ?? true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isDarkMode() async {
    try {
      final setting = await (select(settings)).getSingleOrNull();
      return setting?.isDarkMode ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setDarkMode(bool value) async {
    try {
      final existing = await (select(settings)).getSingleOrNull();
      if (existing == null) {
        await into(
          settings,
        ).insert(SettingsCompanion.insert(isDarkMode: Value(value)));
      } else {
        await update(settings).replace(existing.copyWith(isDarkMode: value));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setAutoSaveEnabled(bool value) async {
    try {
      final existing = await (select(settings)).getSingleOrNull();
      if (existing == null) {
        await into(
          settings,
        ).insert(SettingsCompanion.insert(isAutoSaveEnabled: Value(value)));
      } else {
        await update(
          settings,
        ).replace(existing.copyWith(isAutoSaveEnabled: value));
      }
    } catch (e) {
      rethrow;
    }
  }
}
