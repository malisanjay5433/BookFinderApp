import '../../../../core/database/database_helper.dart';
import '../../domain/entities/saved_book.dart';

abstract class BookLocalDataSource {
  Future<void> saveBook(SavedBook book);
  Future<List<SavedBook>> getAllSavedBooks();
  Future<SavedBook?> getSavedBook(String id);
  Future<void> deleteBook(String id);
  Future<bool> isBookSaved(String id);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final DatabaseHelper _databaseHelper;

  BookLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<void> saveBook(SavedBook book) async {
    await _databaseHelper.insertBook(book.toMap());
  }

  @override
  Future<List<SavedBook>> getAllSavedBooks() async {
    final maps = await _databaseHelper.getAllSavedBooks();
    return maps.map((map) => SavedBook.fromMap(map)).toList();
  }

  @override
  Future<SavedBook?> getSavedBook(String id) async {
    final map = await _databaseHelper.getSavedBook(id);
    return map != null ? SavedBook.fromMap(map) : null;
  }

  @override
  Future<void> deleteBook(String id) async {
    await _databaseHelper.deleteBook(id);
  }

  @override
  Future<bool> isBookSaved(String id) async {
    return await _databaseHelper.isBookSaved(id);
  }
}
