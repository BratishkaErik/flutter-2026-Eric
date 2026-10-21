import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBook = await Navigator.of(context).push<Book>(
            MaterialPageRoute(builder: (_) => const AddBookScreen()),
          );
          if (newBook == null || !mounted) return;
          setState(() => _books.add(newBook));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${_books.length}',
                            style: textTheme.headlineSmall,
                          ),
                          Text('Books', style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${totalPages(_books)}',
                            style: textTheme.headlineSmall,
                          ),
                          Text('Pages', style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${unread(_books).length}',
                            style: textTheme.headlineSmall,
                          ),
                          Text('Unread', style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: Filter.values.map((f) {
                final label = switch (f) {
                  Filter.all => 'All',
                  Filter.unread => 'Unread',
                  Filter.read => 'Read',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _visible.length,
              itemBuilder: (context, index) {
                final book = _visible[index];
                return InkWell(
                  onTap: () async {
                    final action = await Navigator.of(context).push<BookAction>(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(book: book),
                      ),
                    );
                    if (!mounted) return;
                    switch (action) {
                      case BookAction.toggleRead:
                        setState(() => book.read = !book.read);
                      case BookAction.delete:
                        setState(() => _books.remove(book));
                      case null:
                        break;
                    }
                  },
                  child: BookTile(
                    book: book,
                    onToggle: () => setState(() => book.read = !book.read),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
