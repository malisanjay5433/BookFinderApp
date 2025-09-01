import '../../../../core/utils/result.dart';
import '../../domain/entities/book_search_result.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource _remoteDataSource;

  BookRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<BookSearchResult>> searchBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    final result = await _remoteDataSource.searchBooks(
      query: query,
      startIndex: startIndex,
      maxResults: maxResults,
    );

    return result.when(
      success: (data) => Success(
        data.toEntity(
          startIndex: startIndex,
          itemsPerPage: maxResults,
          query: query,
        ),
      ),
      failure: (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<BookSearchResult>> getBooksByCategory({
    required String category,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    // Search for books in a specific category
    final query = 'subject:$category';
    return searchBooks(
      query: query,
      startIndex: startIndex,
      maxResults: maxResults,
    );
  }

  @override
  Future<Result<BookSearchResult>> getNewestBooks({
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    // Search for newest books
    const query = 'newest';
    return searchBooks(
      query: query,
      startIndex: startIndex,
      maxResults: maxResults,
    );
  }
}
