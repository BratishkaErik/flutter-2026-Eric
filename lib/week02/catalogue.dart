import 'models.dart';

class Library {
  final List<LibraryItem> items = [];
  late final DateTime openedAt;
  String? _cachedReport;

  void add(LibraryItem item) => items.add(item);

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  String report() {
    _cachedReport ??= 'Library opened at $openedAt with ${items.length} items.';
    return _cachedReport ?? '';
  }

  Iterable<Book> get books => items.whereType<Book>();

  Iterable<String> get allTitles => items.map((item) => item.title);

  Iterable<Book> get booksAfter2010 => books.where((book) => book.year > 2010);

  // No reduce because reduce throws a StateError if the collection is empty
  double get averagePages =>
      books.fold(0, (sum, b) => sum + b.pages) / books.length;

  Map<String, int> get authorBookCount => books.fold({}, (map, book) {
    final author = book.author.name;
    map[author] = (map[author] ?? 0) + 1;
    return map;
  });

  Set<String> get distinctAuthors => books.map((b) => b.author.name).toSet();

  Set<Genre> get presentGenres => books.map((b) => b.genre).toSet();

  List<String> get displayList => [
    'CATALOGUE',
    for (final Book(:title, :year) in books) '$title ($year)',
    ...distinctAuthors,
    if (books.any((b) => b.pages == 0)) '(incomplete data)',
  ];
}