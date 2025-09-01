import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bookfinder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_books(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authors TEXT NOT NULL,
        description TEXT,
        thumbnail_url TEXT,
        published_date TEXT,
        publisher TEXT,
        page_count INTEGER,
        categories TEXT,
        language TEXT,
        average_rating REAL,
        ratings_count INTEGER,
        isbn TEXT,
        preview_link TEXT,
        info_link TEXT,
        saved_at INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    return await db.insert('saved_books', book);
  }

  Future<List<Map<String, dynamic>>> getAllSavedBooks() async {
    final db = await database;
    return await db.query('saved_books', orderBy: 'saved_at DESC');
  }

  Future<Map<String, dynamic>?> getSavedBook(String id) async {
    final db = await database;
    final result = await db.query(
      'saved_books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteBook(String id) async {
    final db = await database;
    return await db.delete(
      'saved_books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isBookSaved(String id) async {
    final db = await database;
    final result = await db.query(
      'saved_books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
