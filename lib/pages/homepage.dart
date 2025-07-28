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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteTaking()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            NoteTile(
              note: NoteModel(title: 'Test Title', content: 'Test Content'),
            ),
            NoteTile(
              note: NoteModel(title: 'Test Title 2', content: 'Test Content 2'),
            ),
            NoteTile(
              note: NoteModel(title: 'Test Title 3', content: 'Test Content 3'),
            ),
          ],
        ),
      ),
    );
  }
}
