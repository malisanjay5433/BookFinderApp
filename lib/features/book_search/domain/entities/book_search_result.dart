import 'book.dart';

class BookSearchResult {
  final List<Book> books;
  final int totalItems;
  final int startIndex;
  final int itemsPerPage;
  final String? query;

  const BookSearchResult({
    required this.books,
    required this.totalItems,
    required this.startIndex,
    required this.itemsPerPage,
    this.query,
  });

  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      books: (json['books'] as List<dynamic>?)
              ?.map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: json['totalItems'] as int,
      startIndex: json['startIndex'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      query: json['query'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'books': books.map((book) => book.toJson()).toList(),
      'totalItems': totalItems,
      'startIndex': startIndex,
      'itemsPerPage': itemsPerPage,
      'query': query,
    };
  }

  BookSearchResult copyWith({
    List<Book>? books,
    int? totalItems,
    int? startIndex,
    int? itemsPerPage,
    String? query,
  }) {
    return BookSearchResult(
      books: books ?? this.books,
      totalItems: totalItems ?? this.totalItems,
      startIndex: startIndex ?? this.startIndex,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookSearchResult &&
          runtimeType == other.runtimeType &&
          totalItems == other.totalItems &&
          startIndex == other.startIndex &&
          itemsPerPage == other.itemsPerPage &&
          query == other.query;

  @override
  int get hashCode =>
      totalItems.hashCode ^
      startIndex.hashCode ^
      itemsPerPage.hashCode ^
      query.hashCode;
}