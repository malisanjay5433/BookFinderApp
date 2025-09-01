import '../../../../core/utils/result.dart';
import '../entities/book.dart';
import '../entities/saved_book.dart';
import '../repositories/book_repository.dart';

class SaveBookUsecase {
  final BookRepository _repository;

  SaveBookUsecase(this._repository);

  Future<Result<void>> call(Book book) async {
    try {
      final savedBook = SavedBook.fromBook(book);
      await _repository.saveBook(savedBook);
      return const Success(null);
    } catch (e) {
      return ResultFailure(
        UnknownFailure(message: 'Failed to save book: $e'),
      );
    }
  }
}
