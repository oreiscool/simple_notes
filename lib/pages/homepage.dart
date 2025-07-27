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
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            NoteTile(
              note: NoteModel(title: 'Test Title', content: 'Test Content'),
            ),
          ],
        ),
      ),
    );
  }
}
