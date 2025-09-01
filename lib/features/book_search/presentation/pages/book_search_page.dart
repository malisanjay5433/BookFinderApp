import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_search_provider.dart';
import '../widgets/book_search_bar.dart';
import '../widgets/book_list.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/shimmer_book_card.dart';
import 'saved_books_page.dart';

class BookSearchPage extends ConsumerStatefulWidget {
  const BookSearchPage({super.key});

  @override
  ConsumerState<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends ConsumerState<BookSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(bookSearchNotifierProvider.notifier).searchBooks(query: query);
    }
  }

  Future<void> _refreshSearch() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      await ref.read(bookSearchNotifierProvider.notifier).searchBooks(query: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(bookSearchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SavedBooksPage(),
                ),
              );
            },
            tooltip: 'View saved books',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BookSearchBar(
              controller: _searchController,
              onSearch: _performSearch,
            ),
          ),
          Expanded(
            child: searchState.when(
              data: (result) {
                if (result == null) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Search for books',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Enter a book title, author, or keyword',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refreshSearch,
                  child: BookList(
                    books: result.books,
                    onLoadMore: () {
                      ref.read(bookSearchNotifierProvider.notifier).loadMoreBooks();
                    },
                    hasMore: result.books.length < result.totalItems,
                  ),
                );
              },
              loading: () => const ShimmerBookList(itemCount: 6),
              error: (error, stack) => custom.ErrorWidget(
                error: error,
                onRetry: _performSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
