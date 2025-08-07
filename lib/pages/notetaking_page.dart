import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/provider/notes_database_provider.dart';

class NoteTakingPage extends ConsumerStatefulWidget {
  const NoteTakingPage({super.key, this.note, this.noteIndex});
  final Note? note;
  final int? noteIndex;
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

  void saveOrUpdateNote() {
    final db = ref.read(notesDataBaseProvider);
    db.loadData();
    String title = _titleController.text;
    String content = _contentController.text;

    if (widget.noteIndex != null) {
      db.notesList[widget.noteIndex!] = Note(title: title, content: content);
    } else {
      db.notesList.add(Note(title: title, content: content));
    }
    db.updateData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note Saved!')));
    Navigator.pop(context, true);
  }

  void deleteNote() {
    final db = ref.read(notesDataBaseProvider);
    if (widget.noteIndex != null) {
      db.loadData();
      db.deleteNote(widget.noteIndex!);
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
                hint: Text('Title...'),
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
                  hint: Text('Content...'),
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
