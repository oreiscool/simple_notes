import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/widgets/note_tile.dart';
import 'package:simple_notes/pages/notetaking_page.dart';
import 'package:simple_notes/provider/notes_database_provider.dart';
import 'package:simple_notes/pages/settings_page.dart';
import 'package:simple_notes/pages/search_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(notesDataBaseProvider).loadData();
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
          ref.read(notesDataBaseProvider).loadData();
        });
      }
    });
  }

  void createNewNote() {
    goToNotePage();
  }

  @override
  Widget build(BuildContext context) {
    final notesList = ref.read(notesDataBaseProvider).notesList;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          },
          icon: Icon(Icons.search),
        ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: createNewNote,
          child: const Icon(Icons.add),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          return NoteTile(
            onTap: () {
              Future.delayed(Duration(milliseconds: 100), () {
                goToNotePage(note: notesList[index], index: index);
              });
            },
            note: notesList[index],
          );
        },
      ),
    );
  }
}
