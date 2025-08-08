import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/models/note_model.dart';
import 'package:simple_notes/provider/database_provider.dart';
import 'package:simple_notes/widgets/note_tile.dart';
import 'package:simple_notes/pages/notetaking_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  List<Note> _searchResults = [];

  @override
  void initState() {
    super.initState();
  }

  void searchNotes(String query) async {
    final db = ref.read(databaseProvider);
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final results = await db.searchNotes(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: searchNotes,
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
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final note = _searchResults[index];
          return NoteTile(
            note: note,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteTakingPage(note: note),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
