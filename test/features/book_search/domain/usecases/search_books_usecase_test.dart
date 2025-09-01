import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bookfinderapp/features/book_search/domain/entities/book.dart';
import 'package:bookfinderapp/features/book_search/domain/entities/book_search_result.dart';
import 'package:bookfinderapp/features/book_search/domain/repositories/book_repository.dart';
import 'package:bookfinderapp/features/book_search/domain/usecases/search_books_usecase.dart';
import 'package:bookfinderapp/core/errors/failures.dart';
import 'package:bookfinderapp/core/utils/result.dart';

import 'search_books_usecase_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  // Provide dummy values for Mockito
  provideDummy<Result<BookSearchResult>>(Success(BookSearchResult(
    books: [],
    totalItems: 0,
    query: '',
    startIndex: 0,
    itemsPerPage: 10,
  )));
  late SearchBooksUsecase usecase;
  late MockBookRepository mockRepository;

  setUp(() {
    mockRepository = MockBookRepository();
    usecase = SearchBooksUsecase(mockRepository);
  });

  group('SearchBooksUsecase', () {
    const tQuery = 'flutter';
    const tStartIndex = 0;
    const tMaxResults = 10;

    final tBook = Book(
      id: '1',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      publishedDate: '2020-01-01',
      description: 'A comprehensive guide to Flutter development',
      thumbnailUrl: 'https://example.com/cover.jpg',
      averageRating: 4.5,
      ratingsCount: 100,
      pageCount: 300,
      language: 'en',
      isbn: '9781617296147',
      previewLink: 'https://example.com/preview',
      infoLink: 'https://example.com/info',
    );

    final tBookSearchResult = BookSearchResult(
      books: [tBook],
      totalItems: 1,
      query: tQuery,
      startIndex: tStartIndex,
      itemsPerPage: tMaxResults,
    );

    test('should return BookSearchResult when repository call is successful', () async {
      // Arrange
      when(mockRepository.searchBooks(
        query: anyNamed('query'),
        startIndex: anyNamed('startIndex'),
        maxResults: anyNamed('maxResults'),
      )).thenAnswer((_) async => Success(tBookSearchResult));

      // Act
      final result = await usecase(
        query: tQuery,
        startIndex: tStartIndex,
        maxResults: tMaxResults,
      );

      // Assert
      expect(result, isA<Success<BookSearchResult>>());
      expect((result as Success).data, equals(tBookSearchResult));
      verify(mockRepository.searchBooks(
        query: tQuery,
        startIndex: tStartIndex,
        maxResults: tMaxResults,
      ));
    });

    test('should return ValidationFailure when query is empty', () async {
      // Act
      final result = await usecase(
        query: '',
        startIndex: tStartIndex,
        maxResults: tMaxResults,
      );

      // Assert
      expect(result, isA<ResultFailure<BookSearchResult>>());
      expect((result as ResultFailure).failure, isA<ValidationFailure>());
      verifyNever(mockRepository.searchBooks(
        query: anyNamed('query'),
        startIndex: anyNamed('startIndex'),
        maxResults: anyNamed('maxResults'),
      ));
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      when(mockRepository.searchBooks(
        query: anyNamed('query'),
        startIndex: anyNamed('startIndex'),
        maxResults: anyNamed('maxResults'),
      )).thenAnswer((_) async => ResultFailure(ServerFailure(message: 'Server error')));

      // Act
      final result = await usecase(
        query: tQuery,
        startIndex: tStartIndex,
        maxResults: tMaxResults,
      );

      // Assert
      expect(result, isA<ResultFailure<BookSearchResult>>());
      expect((result as ResultFailure).failure, isA<ServerFailure>());
    });
  });
}
