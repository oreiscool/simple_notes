import 'package:flutter/material.dart';
import 'package:simple_notes/models/notemodel.dart';
import 'package:simple_notes/widgets/notetile.dart';
import 'package:simple_notes/pages/notetaking.dart';
import 'package:simple_notes/data/database.dart';

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
        builder: (context) => NoteTaking(note: note, noteIndex: index),
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
