import 'book.dart';

class SavedBook {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final List<String>? categories;
  final String? language;
  final double? averageRating;
  final int? ratingsCount;
  final String? isbn;
  final String? previewLink;
  final String? infoLink;
  final DateTime savedAt;

  const SavedBook({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnailUrl,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.categories,
    this.language,
    this.averageRating,
    this.ratingsCount,
    this.isbn,
    this.previewLink,
    this.infoLink,
    required this.savedAt,
  });

  factory SavedBook.fromBook(Book book) {
    return SavedBook(
      id: book.id,
      title: book.title,
      authors: book.authors,
      description: book.description,
      thumbnailUrl: book.thumbnailUrl,
      publishedDate: book.publishedDate,
      publisher: book.publisher,
      pageCount: book.pageCount,
      categories: book.categories,
      language: book.language,
      averageRating: book.averageRating,
      ratingsCount: book.ratingsCount,
      isbn: book.isbn,
      previewLink: book.previewLink,
      infoLink: book.infoLink,
      savedAt: DateTime.now(),
    );
  }

  factory SavedBook.fromMap(Map<String, dynamic> map) {
    return SavedBook(
      id: map['id'] as String,
      title: map['title'] as String,
      authors: (map['authors'] as String).split(','),
      description: map['description'] as String?,
      thumbnailUrl: map['thumbnail_url'] as String?,
      publishedDate: map['published_date'] as String?,
      publisher: map['publisher'] as String?,
      pageCount: map['page_count'] as int?,
      categories: map['categories'] != null 
          ? (map['categories'] as String).split(',')
          : null,
      language: map['language'] as String?,
      averageRating: map['average_rating'] as double?,
      ratingsCount: map['ratings_count'] as int?,
      isbn: map['isbn'] as String?,
      previewLink: map['preview_link'] as String?,
      infoLink: map['info_link'] as String?,
      savedAt: DateTime.fromMillisecondsSinceEpoch(map['saved_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors.join(','),
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'published_date': publishedDate,
      'publisher': publisher,
      'page_count': pageCount,
      'categories': categories?.join(','),
      'language': language,
      'average_rating': averageRating,
      'ratings_count': ratingsCount,
      'isbn': isbn,
      'preview_link': previewLink,
      'info_link': infoLink,
      'saved_at': savedAt.millisecondsSinceEpoch,
    };
  }

  Book toBook() {
    return Book(
      id: id,
      title: title,
      authors: authors,
      description: description,
      thumbnailUrl: thumbnailUrl,
      publishedDate: publishedDate,
      publisher: publisher,
      pageCount: pageCount,
      categories: categories,
      language: language,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      isbn: isbn,
      previewLink: previewLink,
      infoLink: infoLink,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedBook &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
