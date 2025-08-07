import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/provider/notes_database_provider.dart';
import 'package:simple_notes/widgets/note_tile.dart';
import 'package:simple_notes/pages/notetaking_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];

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

  @override
  void initState() {
    super.initState();
    _allNotes = ref.read(notesDataBaseProvider).notesList;
    _filteredNotes = [];
  }

  void _filterNotes(String query) {
    List<Note> results = [];
    if (query.isEmpty) {
      results = [];
    } else {
      results = _allNotes.where((note) {
        final titleMatch = note.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        final contentMatch = note.content.toLowerCase().contains(
          query.toLowerCase(),
        );
        return titleMatch || contentMatch;
      }).toList();
    }
    setState(() {
      _filteredNotes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _filterNotes,
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          return NoteTile(
            onTap: () {
              Future.delayed(Duration(milliseconds: 100), () {
                goToNotePage(note: _filteredNotes[index], index: index);
              });
            },
            note: _filteredNotes[index],
          );
        },
      ),
    );
  }
}
