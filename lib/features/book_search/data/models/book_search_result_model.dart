import '../../domain/entities/book_search_result.dart';
import 'book_model.dart';

class BookSearchResultModel {
  final int totalItems;
  final List<BookModel> items;

  const BookSearchResultModel({
    required this.totalItems,
    required this.items,
  });

  factory BookSearchResultModel.fromJson(Map<String, dynamic> json) {
    return BookSearchResultModel(
      totalItems: json['totalItems'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => BookModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  BookSearchResult toEntity({
    int startIndex = 0,
    int itemsPerPage = 10,
    String? query,
  }) {
    return BookSearchResult(
      books: items.map((item) => item.toEntity()).toList(),
      totalItems: totalItems,
      startIndex: startIndex,
      itemsPerPage: itemsPerPage,
      query: query,
    );
  }
}