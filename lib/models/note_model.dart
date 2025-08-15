import 'package:drift/drift.dart';
import 'package:simple_notes/data/database.dart';
import 'package:intl/intl.dart';

class NoteModel {
  final int id;
  final String title;
  final String content;
  final DateTime lastModified;
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.lastModified,
    this.isPinned = false,
  });

  factory NoteModel.create({required String title, required String content}) {
    final now = DateTime.now();
    return NoteModel(
      id: 0,
      title: title,
      content: content,
      lastModified: now,
      isPinned: false,
    );
  }

  factory NoteModel.fromDatabase(Note dbNote) {
    return NoteModel(
      id: dbNote.id,
      title: dbNote.title,
      content: dbNote.content,
      lastModified: dbNote.lastModified,
      isPinned: dbNote.isPinned,
    );
  }
  NotesCompanion toDatabaseCompanion() {
    return NotesCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      title: Value(title),
      content: Value(content),
      lastModified: Value(lastModified),
      isPinned: Value(isPinned),
    );
  }

  NoteModel copyWith({
    String? title,
    String? content,
    DateTime? lastModified,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;
  bool get hasContent => !isEmpty;
  String get preview =>
      content.length > 100 ? '${content.substring(0, 100)}...' : content;
  String get formattedLastModified {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastModifiedDate = DateTime(
      lastModified.year,
      lastModified.month,
      lastModified.day,
    );
    if (lastModifiedDate == today) {
      return DateFormat.jm().format(lastModified);
    } else if (now.difference(lastModified).inDays < 7) {
      return DateFormat.E().format(lastModified);
    } else if (lastModified.year == now.year) {
      return DateFormat('MMM d').format(lastModified);
    } else {
      return DateFormat('MMM d, y').format(lastModified);
    }
  }

  @override
  String toString() => 'NoteModel(id: $id, title: $title)';
}
