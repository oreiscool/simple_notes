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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (widget.noteIndex != null) {
                db.loadData();
                db.deleteNote(widget.noteIndex!);
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Note Deleted!')));
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete_outline_rounded),
          ),
          SizedBox(width: 35),
          IconButton(
            onPressed: () {
              var newNote = Note(
                title: _titleController.text,
                content: _contentController.text,
              );
              db.loadData();
              db.notesList.add(newNote);
              db.updateData();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Note Saved!')));
              Navigator.pop(context);
            },
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
                hint: Text('Title'),
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
                  hint: Text('Type here...'),
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
