import 'package:flutter/material.dart';
import 'package:simple_notes/data/database.dart';
import 'package:simple_notes/models/notemodel.dart';

class NoteTaking extends StatefulWidget {
  const NoteTaking({super.key, this.note, this.noteIndex});
  final Note? note;
  final int? noteIndex;
  @override
  State<NoteTaking> createState() => _NoteTakingState();
}

class _NoteTakingState extends State<NoteTaking> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final db = NotesDataBase();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void saveOrUpdateNote() {
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
              controller: _titleController,
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
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 18),
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
