import 'package:flutter/material.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/widgets/note_tile.dart';
import 'package:simple_notes/pages/notetaking_page.dart';
import 'package:simple_notes/data/notes_database.dart';
import 'package:simple_notes/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotesDataBase db = NotesDataBase();

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  void goToNotePage({Note? note, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteTakingPage(note: note, noteIndex: index),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {
          db.loadData();
        });
      }
    });
  }

  void createNewNote() {
    goToNotePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        title: const Text(
          'Simple Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FloatingActionButton(
          onPressed: createNewNote,
          child: const Icon(Icons.add),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: db.notesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              goToNotePage(note: db.notesList[index], index: index);
            },
            child: NoteTile(note: db.notesList[index]),
          );
        },
      ),
    );
  }
}
