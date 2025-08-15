import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_notes/provider/database_provider.dart';
import 'package:simple_notes/widgets/note_tile.dart';
import 'package:simple_notes/pages/notetaking_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchNotesProvider);
    final currentQuery = ref.watch(searchQueryProvider);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (query) {
            ref.read(searchQueryProvider.notifier).updateQuery(query);
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchResults.when(
        data: (notes) {
          if (notes.isEmpty && currentQuery.isNotEmpty) {
            return const Center(
              child: Text('No results found.', style: TextStyle(fontSize: 18)),
            );
          }
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Start typing to search notes.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteTile(
                heroTagPrefix: 'search',
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NoteTakingPage(note: note, heroTagPrefix: 'search'),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
