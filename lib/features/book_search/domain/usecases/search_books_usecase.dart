
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/book_search_result.dart';
import '../repositories/book_repository.dart';

class SearchBooksUsecase {
  final BookRepository _repository;

  SearchBooksUsecase(this._repository);

  Future<Result<BookSearchResult>> call({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    if (query.trim().isEmpty) {
      return const ResultFailure(
        ValidationFailure(message: 'Search query cannot be empty'),
      );
    }

    return await _repository.searchBooks(
      query: query.trim(),
      startIndex: startIndex,
      maxResults: maxResults,
    );
  }
}
