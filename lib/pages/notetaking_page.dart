import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/provider/database_provider.dart';
import 'package:simple_notes/provider/settings_provider.dart';

class NoteTakingPage extends ConsumerStatefulWidget {
  const NoteTakingPage({this.note, super.key});
  final NoteModel? note;
  @override
  ConsumerState<NoteTakingPage> createState() => _NoteTakingState();
}

class _NoteTakingState extends ConsumerState<NoteTakingPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Timer? _autoSaveTimer;
  int? _currentNoteId;
  String _lastSavedTitle = '';
  String _lastSavedContent = '';
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _currentNoteId = widget.note!.id;
      _lastSavedTitle = widget.note!.title;
      _lastSavedContent = widget.note!.content;
    }
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isAutoSaveEnabled = ref.read(autoSaveProvider);
    if (!isAutoSaveEnabled) return;

    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _performAutoSave);
  }

  Future<void> _performAutoSave() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if ((title == _lastSavedTitle && content == _lastSavedContent) ||
        (title.isEmpty && content.isEmpty)) {
      return;
    }

    try {
      final database = ref.read(databaseProvider);
      if (_currentNoteId == null) {
        _currentNoteId = await database.createNote(
          title: title,
          content: content,
        );
      } else {
        await database.updateNote(
          id: _currentNoteId!,
          title: title,
          content: content,
        );
      }
      _lastSavedTitle = title;
      _lastSavedContent = content;
    } catch (e) {
      debugPrint('Auto-save failed: $e');
    }
  }

  Future<void> saveOrUpdateNote() async {
    final database = ref.read(databaseProvider);
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.trim().isEmpty && content.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }
    if (widget.note == null) {
      await database.createNote(title: title, content: content);
    } else {
      await database.updateNote(
        id: widget.note!.id,
        title: title,
        content: content,
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note Saved!')));
    Navigator.pop(context, true);
  }

  Future<void> deleteNote() async {
    if (widget.note == null) {
      return;
    }
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (didConfirm == true) {
      final database = ref.read(databaseProvider);
      await database.deleteNote(widget.note!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note Deleted!')));
      Navigator.pop(context, true);
    }
  }

  Future<void> pinNote() async {
    if (widget.note == null) {
      return;
    }
    await ref.read(databaseProvider).toggleNotePin(widget.note!.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !widget.note!.isPinned ? 'Note Unpinned!' : 'Note Pinned!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteAsyncValue = ref.watch(singleNoteProvider(widget.note?.id ?? 0));
    final currentNote = noteAsyncValue.asData?.value;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: deleteNote,
            icon: Icon(Icons.delete_outline_rounded),
          ),
          IconButton(
            onPressed: pinNote,
            icon: Icon(
              currentNote?.isPinned ?? false
                  ? Icons.push_pin_rounded
                  : Icons.push_pin_outlined,
            ),
          ),
          IconButton(
            onPressed: saveOrUpdateNote,
            icon: Icon(Icons.save_alt_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              autofocus: widget.note == null,
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              decoration: InputDecoration(
                border: InputBorder.none,
                hint: const Text('Title'),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hint: const Text('Content'),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
