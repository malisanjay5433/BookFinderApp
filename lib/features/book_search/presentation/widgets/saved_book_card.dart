import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/saved_book.dart';
import '../providers/book_search_provider.dart';


class SavedBookCard extends ConsumerStatefulWidget {
  final SavedBook savedBook;
  final VoidCallback onBookDeleted;

  const SavedBookCard({
    super.key,
    required this.savedBook,
    required this.onBookDeleted,
  });

  @override
  ConsumerState<SavedBookCard> createState() => _SavedBookCardState();
}

class _SavedBookCardState extends ConsumerState<SavedBookCard> {
  bool _isDeleting = false;

  Future<void> _deleteBook() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final repository = ref.read(bookRepositoryProvider);
      await repository.deleteBook(widget.savedBook.id);
      
      if (mounted) {
        widget.onBookDeleted();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book removed from favorites'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text(
          'Are you sure you want to remove "${widget.savedBook.title}" from your favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteBook();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to book details
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SavedBookDetailsPage(
                savedBook: widget.savedBook,
                onBookDeleted: widget.onBookDeleted,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.savedBook.thumbnailUrl != null
                    ? Image.network(
                        widget.savedBook.thumbnailUrl!,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.book,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.savedBook.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.savedBook.authors.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.savedBook.publishedDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Published: ${widget.savedBook.publishedDate}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                    if (widget.savedBook.averageRating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.savedBook.averageRating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (widget.savedBook.ratingsCount != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '(${widget.savedBook.ratingsCount})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Saved on ${_formatDate(widget.savedBook.savedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                onPressed: _isDeleting ? null : _showDeleteConfirmation,
                icon: _isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                tooltip: 'Remove from favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class SavedBookDetailsPage extends ConsumerStatefulWidget {
  final SavedBook savedBook;
  final VoidCallback onBookDeleted;

  const SavedBookDetailsPage({
    super.key,
    required this.savedBook,
    required this.onBookDeleted,
  });

  @override
  ConsumerState<SavedBookDetailsPage> createState() => _SavedBookDetailsPageState();
}

class _SavedBookDetailsPageState extends ConsumerState<SavedBookDetailsPage> {
  bool _isDeleting = false;

  Future<void> _deleteBook() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final repository = ref.read(bookRepositoryProvider);
      await repository.deleteBook(widget.savedBook.id);
      
      if (mounted) {
        widget.onBookDeleted();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book removed from favorites'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Widget _buildBookDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.savedBook.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Authors
        if (widget.savedBook.authors.isNotEmpty) ...[
          Text(
            'By ${widget.savedBook.authors.join(', ')}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Rating
        if (widget.savedBook.averageRating != null) ...[
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                widget.savedBook.averageRating!.toStringAsFixed(1),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (widget.savedBook.ratingsCount != null) ...[
                const SizedBox(width: 8),
                Text(
                  '(${widget.savedBook.ratingsCount} ratings)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
        
        // Description
        if (widget.savedBook.description != null && widget.savedBook.description!.isNotEmpty) ...[
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.savedBook.description!,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],
        
        // Book Details
        const Text(
          'Book Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        _buildDetailRow('Published', widget.savedBook.publishedDate),
        _buildDetailRow('Publisher', widget.savedBook.publisher),
        _buildDetailRow('Pages', widget.savedBook.pageCount?.toString()),
        _buildDetailRow('Language', widget.savedBook.language),
        _buildDetailRow('ISBN', widget.savedBook.isbn),
        if (widget.savedBook.categories != null && widget.savedBook.categories!.isNotEmpty)
          _buildDetailRow('Categories', widget.savedBook.categories?.join(', ')),
        
        const SizedBox(height: 24),
        
        // Action Buttons
        Row(
          children: [
            if (widget.savedBook.previewLink != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle preview link
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('Preview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            if (widget.savedBook.previewLink != null && widget.savedBook.infoLink != null)
              const SizedBox(width: 12),
            if (widget.savedBook.infoLink != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle info link
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('More Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isDeleting ? null : _deleteBook,
            icon: _isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.delete_outline),
            tooltip: 'Remove from favorites',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animated book cover
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'book_cover_${widget.savedBook.id}',
                  child: Container(
                    width: 200,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.savedBook.thumbnailUrl != null
                          ? Image.network(
                              widget.savedBook.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.book,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.book,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            // Book details content
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBookDetailsContent(),
            ),
          ],
        ),
      ),
    );
  }
}
