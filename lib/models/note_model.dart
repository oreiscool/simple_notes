import 'package:drift/drift.dart';
import 'package:simple_notes/data/database.dart';

class NoteModel {
  final int id;
  final String title;
  final String content;
  final DateTime lastModified;
  final List<String> tags;
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.lastModified,
    this.tags = const [],
    this.isPinned = false,
  });

  factory NoteModel.create({required String title, required String content}) {
    final now = DateTime.now();
    return NoteModel(
      id: 0,
      title: title,
      content: content,
      lastModified: now,
      tags: const [],
      isPinned: false,
    );
  }

  factory NoteModel.fromDatabase(Note dbNote) {
    return NoteModel(
      id: dbNote.id,
      title: dbNote.title,
      content: dbNote.content,
      lastModified: dbNote.lastModified,
    );
  }

  NotesCompanion toDatabaseCompanion() {
    return NotesCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      title: Value(title),
      content: Value(content),
      lastModified: Value(lastModified),
    );
  }

  NoteModel copyWith({
    String? title,
    String? content,
    DateTime? lastModified,
    List<String>? tags,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;
  bool get hasContent => !isEmpty;
  String get preview =>
      content.length > 100 ? '${content.substring(0, 100)}...' : content;

  @override
  String toString() => 'NoteModel(id: $id, title: $title)';
}
