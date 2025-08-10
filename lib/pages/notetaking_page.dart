import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/data/database.dart';
import 'package:simple_notes/provider/database_provider.dart';

class NoteTakingPage extends ConsumerStatefulWidget {
  const NoteTakingPage({super.key, this.note});
  final Note? note;
  @override
  ConsumerState<NoteTakingPage> createState() => _NoteTakingState();
}

class _NoteTakingState extends ConsumerState<NoteTakingPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void saveOrUpdateNote() async {
    final db = ref.read(databaseProvider);

    if (widget.note != null) {
      final noteToUpdate = widget.note!;
      noteToUpdate.title = _titleController.text;
      noteToUpdate.content = _contentController.text;
      noteToUpdate.lastModified = DateTime.now();
      await db.updateNote(noteToUpdate);
    } else {
      final newNote = Note()
        ..title = _titleController.text
        ..content = _contentController.text
        ..lastModified = DateTime.now();
      await db.createNote(newNote);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note Saved!')));
    Navigator.pop(context, true);
  }

  Future<void> deleteNote() async {
    final db = ref.read(databaseProvider);
    if (widget.note != null) {
      await db.deleteNote(widget.note!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note Deleted!')));
      Navigator.pop(context, true);
    }
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
          SizedBox(width: 12),
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
                hint: Text('Title'),
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
                  hint: Text('Content'),
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
