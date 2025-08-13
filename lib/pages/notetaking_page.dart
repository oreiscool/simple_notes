import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/provider/database_provider.dart';

class NoteTakingPage extends ConsumerStatefulWidget {
  const NoteTakingPage({this.note, super.key});
  final NoteModel? note;
  @override
  ConsumerState<NoteTakingPage> createState() => _NoteTakingState();
}

class _NoteTakingState extends ConsumerState<NoteTakingPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  NoteModel? _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    if (_currentNote != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> saveOrUpdateNote() async {
    final db = ref.read(databaseProvider);
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.trim().isEmpty && content.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }
    if (widget.note == null) {
      await db.createNote(title: title, content: content);
    } else {
      await db.updateNote(id: widget.note!.id, title: title, content: content);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note Saved!')));
    Navigator.pop(context, true);
  }

  Future<void> deleteNote() async {
    if (_currentNote == null) {
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
      final db = ref.read(databaseProvider);
      await db.deleteNote(widget.note!.id);
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
    final db = ref.read(databaseProvider);
    final updatedNote = widget.note!.copyWith(
      isPinned: !_currentNote!.isPinned,
    );
    await db.updateNote(
      id: updatedNote.id,
      title: updatedNote.title,
      content: updatedNote.content,
      isPinned: updatedNote.isPinned,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(updatedNote.isPinned ? 'Note Pinned!' : 'Note Unpinned!'),
      ),
    );
    setState(() {
      _currentNote = updatedNote;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              _currentNote?.isPinned ?? false
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
