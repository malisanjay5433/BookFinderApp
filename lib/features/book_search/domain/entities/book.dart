class Book {
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

  const Book({
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
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)?.cast<String>() ?? [],
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      publishedDate: json['publishedDate'] as String?,
      publisher: json['publisher'] as String?,
      pageCount: json['pageCount'] as int?,
      categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
      language: json['language'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      ratingsCount: json['ratingsCount'] as int?,
      isbn: json['isbn'] as String?,
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'pageCount': pageCount,
      'categories': categories,
      'language': language,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'isbn': isbn,
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}