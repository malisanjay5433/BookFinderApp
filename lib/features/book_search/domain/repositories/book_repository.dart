import '../../../../core/utils/result.dart';
import '../entities/book_search_result.dart';

abstract class BookRepository {
  Future<Result<BookSearchResult>> searchBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  });

  Future<Result<BookSearchResult>> getBooksByCategory({
    required String category,
    int startIndex = 0,
    int maxResults = 10,
  });

  Future<Result<BookSearchResult>> getNewestBooks({
    int startIndex = 0,
    int maxResults = 10,
  });
}
