class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() {
    return "Author: $name from $country";
  }
}

enum Genre {
  craft("Craft"),
  theory("Theory"),
  unknown("Unknown");

  final String label;

  const Genre(this.label);

  factory Genre.fromString(String? raw) => switch (raw?.toLowerCase()) {
    "craft" => Genre.craft,
    "theory" => Genre.theory,
    "unknown" || null => Genre.unknown,
    _ => Genre.unknown,
  };
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  String describe();

  bool get isOld => year < 2010;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'BORROW: $title ($year)';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  const Book.missing()
    : this(
        title: "Unknown Title",
        year: 0,
        pages: 0,
        author: const Author(name: "Unknown Author", country: null),
        genre: Genre.unknown,
        description: null,
      );

  Book.fromJson(Map<String, dynamic> json)
    : this(
        title: json["title"] is String ? json["title"] as String : "Unknown",
        year: json["year"] is int ? json["year"] as int : 0,
        pages: json["pages"] is int ? json["pages"] as int : 0,
        author: Author(
          name: json["author"] is String
              ? json["author"] as String
              : "Unknown author",
          country: json["country"] is String ? json["country"] as String : null,
        ),
        genre: Genre.fromString(
          json['genre'] is String ? json['genre'] as String : null,
        ),
        description: json['description'] is String
            ? json['description'] as String
            : null,
      );

  bool get isLong {
    return (pages > 400);
  }

  @override
  String describe() {
    return "Book: \"$title\" ($year), $pages pages, genre: ${genre.label}, description: $description";
  }

  @override
  String toString() => describe();
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => 'Magazine: "$title" ($year), Issue #$issue';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  bool get isOld => false;

  @override
  String describe() => 'Ghost: $title ($year)';
}
