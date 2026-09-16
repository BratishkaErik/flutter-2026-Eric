import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  library.open();

  for (final bookJson in rawBooks) {
    library.add(Book.fromJson(bookJson));
  }

  print(library.report());

  print('--- All Titles ---');
  for (final title in library.allTitles) {
    print(title);
  }

  print('\n--- Books after 2010 ---');
  for (final book in library.booksAfter2010) {
    print('${book.title} (${book.year})');
  }

  print('\nAverage pages: ${library.averagePages}');
  print('Books per author: ${library.authorBookCount}');
  print('Distinct authors: ${library.distinctAuthors}');
  print('Present genres: ${library.presentGenres}');

  print('\n--- Display List ---');
  for (final line in library.displayList) {
    print(line);
  }

  final allBooks = library.books.toList();
  final stats = statsOf(allBooks);
  print('\n--- Stats Record ---');
  print('Count: ${stats.count}, Average Pages: ${stats.avgPages}');

  print('\n--- Shelf States ---');
  print(describe(Empty()));
  print(describe(Ready(allBooks)));
  print(describe(Broken('Shelf was stolen')));
}