import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/saved_book.dart';
import '../providers/book_search_provider.dart';
import '../widgets/animated_book_cover.dart';
import '../widgets/book_details_content.dart';

class BookDetailsPage extends ConsumerStatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  ConsumerState<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ConsumerState<BookDetailsPage> {
  bool _isBookSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookSaved();
  }

  Future<void> _checkIfBookSaved() async {
    final repository = ref.read(bookRepositoryProvider);
    final isSaved = await repository.isBookSaved(widget.book.id);
    if (mounted) {
      setState(() {
        _isBookSaved = isSaved;
      });
    }
  }

  Future<void> _toggleSaveBook() async {
    final repository = ref.read(bookRepositoryProvider);
    
    if (_isBookSaved) {
      await repository.deleteBook(widget.book.id);
    } else {
      final savedBook = SavedBook.fromBook(widget.book);
      await repository.saveBook(savedBook);
    }
    
    if (mounted) {
      setState(() {
        _isBookSaved = !_isBookSaved;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookSaved 
                ? 'Book saved to favorites!' 
                : 'Book removed from favorites!',
          ),
          backgroundColor: _isBookSaved ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isBookSaved ? Icons.favorite : Icons.favorite_border,
              color: _isBookSaved ? Colors.red : null,
            ),
            onPressed: _toggleSaveBook,
            tooltip: _isBookSaved ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animated Book Cover
            AnimatedBookCover(
              thumbnailUrl: widget.book.thumbnailUrl,
              title: widget.book.title,
            ),
            
            // Book Details Content
            BookDetailsContent(book: widget.book),
          ],
        ),
      ),
    );
  }
}
