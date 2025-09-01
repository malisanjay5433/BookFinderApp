import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_search_provider.dart';
import '../widgets/saved_book_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/shimmer_book_card.dart';

class SavedBooksPage extends ConsumerStatefulWidget {
  const SavedBooksPage({super.key});

  @override
  ConsumerState<SavedBooksPage> createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends ConsumerState<SavedBooksPage> {
  @override
  void initState() {
    super.initState();
    // Only load if we don't have data yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(savedBooksProvider);
      if (currentState.value?.isEmpty ?? true) {
        _loadSavedBooks();
      }
    });
  }

  Future<void> _loadSavedBooks() async {
    // Trigger loading of saved books
    ref.read(savedBooksProvider.notifier).loadSavedBooks();
  }

  Future<void> _refreshSavedBooks() async {
    await _loadSavedBooks();
  }

  @override
  Widget build(BuildContext context) {
    final savedBooksAsync = ref.watch(savedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate back to search page
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: savedBooksAsync.when(
        data: (savedBooks) {
          if (savedBooks.isEmpty) {
            return _buildEmptyState();
          }
          
          return RefreshIndicator(
            onRefresh: _refreshSavedBooks,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                final savedBook = savedBooks[index];
                return SavedBookCard(
                  savedBook: savedBook,
                  onBookDeleted: () {
                    // Refresh the list after deletion
                    _loadSavedBooks();
                  },
                );
              },
            ),
          );
        },
        loading: () => const ShimmerBookList(itemCount: 4),
        error: (error, stackTrace) => custom.ErrorWidget(
          error: error,
          onRetry: _loadSavedBooks,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved books yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save books you love to see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.search),
            label: const Text('Search Books'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
