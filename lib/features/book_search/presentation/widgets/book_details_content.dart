import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class BookDetailsContent extends StatelessWidget {
  final Book book;

  const BookDetailsContent({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            book.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Authors
          if (book.authors.isNotEmpty) ...[
            Text(
              'By ${book.authors.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Rating
          if (book.averageRating != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  book.averageRating!.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (book.ratingsCount != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${book.ratingsCount} ratings)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Description
          if (book.description != null) ...[
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
          ],
          
          // Book Information
          _buildInfoSection(context),
          
          // Action Buttons
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (book.publishedDate != null)
            _buildInfoRow('Published', book.publishedDate!),
          
          if (book.publisher != null)
            _buildInfoRow('Publisher', book.publisher!),
          
          if (book.pageCount != null)
            _buildInfoRow('Pages', '${book.pageCount}'),
          
          if (book.language != null)
            _buildInfoRow('Language', book.language!),
          
          if (book.isbn != null)
            _buildInfoRow('ISBN', book.isbn!),
          
          if (book.categories != null && book.categories!.isNotEmpty)
            _buildInfoRow('Categories', book.categories!.join(', ')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (book.previewLink != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Open preview link
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preview feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Preview'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        
        if (book.previewLink != null) const SizedBox(width: 12),
        
        if (book.infoLink != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Open info link
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Info link feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('More Info'),
            ),
          ),
      ],
    );
  }
}
