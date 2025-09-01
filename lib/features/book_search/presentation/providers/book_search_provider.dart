import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/book_local_datasource.dart';
import '../../data/datasources/book_remote_datasource.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/entities/book_search_result.dart';
import '../../domain/entities/saved_book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/search_books_usecase.dart';

// Database Helper Provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Remote Data Source Provider
final bookRemoteDataSourceProvider = Provider<BookRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookRemoteDataSourceImpl(apiClient);
});

// Local Data Source Provider
final bookLocalDataSourceProvider = Provider<BookLocalDataSource>((ref) {
  final databaseHelper = ref.watch(databaseHelperProvider);
  return BookLocalDataSourceImpl(databaseHelper);
});

// Repository Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final remoteDataSource = ref.watch(bookRemoteDataSourceProvider);
  final localDataSource = ref.watch(bookLocalDataSourceProvider);
  return BookRepositoryImpl(remoteDataSource, localDataSource);
});

// Use Case Provider
final searchBooksUsecaseProvider = Provider<SearchBooksUsecase>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return SearchBooksUsecase(repository);
});

// Search State Provider
final bookSearchNotifierProvider = StateNotifierProvider<BookSearchNotifier, AsyncValue<BookSearchResult?>>((ref) {
  return BookSearchNotifier(ref);
});

class BookSearchNotifier extends StateNotifier<AsyncValue<BookSearchResult?>> {
  final Ref _ref;

  BookSearchNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> searchBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    state = const AsyncValue.loading();

    try {
      final usecase = _ref.read(searchBooksUsecaseProvider);
      final result = await usecase(
        query: query,
        startIndex: startIndex,
        maxResults: maxResults,
      );

      if (result is Success<BookSearchResult>) {
        state = AsyncValue.data(result.data);
      } else if (result is ResultFailure<BookSearchResult>) {
        state = AsyncValue.error(result.failure, StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data(null);
  }

  Future<void> loadMoreBooks() async {
    final currentState = state.value;
    if (currentState == null) return;

    final usecase = _ref.read(searchBooksUsecaseProvider);
    final nextStartIndex = currentState.startIndex + currentState.itemsPerPage;

    try {
      final result = await usecase(
        query: currentState.query ?? '',
        startIndex: nextStartIndex,
        maxResults: currentState.itemsPerPage,
      );

      if (result is Success<BookSearchResult>) {
        final newData = result.data;
        final updatedBooks = [...currentState.books, ...newData.books];
        final updatedResult = currentState.copyWith(
          books: updatedBooks,
          startIndex: nextStartIndex,
        );
        state = AsyncValue.data(updatedResult);
      } else if (result is ResultFailure<BookSearchResult>) {
        state = AsyncValue.error(result.failure, StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Saved Books State Provider
final savedBooksProvider = StateNotifierProvider<SavedBooksNotifier, AsyncValue<List<SavedBook>>>((ref) {
  return SavedBooksNotifier(ref);
});

class SavedBooksNotifier extends StateNotifier<AsyncValue<List<SavedBook>>> {
  final Ref _ref;

  SavedBooksNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadSavedBooks() async {
    // Only show loading if we don't have any data
    if (state.value?.isEmpty ?? true) {
      state = const AsyncValue.loading();
    }

    try {
      final repository = _ref.read(bookRepositoryProvider);
      final savedBooks = await repository.getAllSavedBooks();
      state = AsyncValue.data(savedBooks);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSavedBook(SavedBook book) async {
    try {
      final repository = _ref.read(bookRepositoryProvider);
      await repository.saveBook(book);
      
      // Reload the list to reflect the change
      await loadSavedBooks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeSavedBook(String bookId) async {
    try {
      final repository = _ref.read(bookRepositoryProvider);
      await repository.deleteBook(bookId);
      
      // Reload the list to reflect the change
      await loadSavedBooks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}