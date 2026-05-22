import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/book_entity.dart';

class BookCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final EdgeInsetsGeometry margin;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onFavoriteTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final chips = _buildChips();

    return Container(
      margin: margin,
      child: Material(
        color: Color(0xFFF5F6F6),
        borderRadius: BorderRadius.circular(18),
        shadowColor: Colors.black.withValues(alpha: 0.3),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BookCover(imageUrl: book.imageUrl),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF17263C),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    book.authors.isEmpty
                                        ? 'Unknown author'
                                        : book.authors.join(', '),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.25,
                                      color: Color(0xFF5C6270),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: onFavoriteTap,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  book.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 30,
                                  color: book.isFavorite
                                      ? Colors.redAccent
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (chips.isNotEmpty)
                          Wrap(spacing: 10, runSpacing: 10, children: chips),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChips() {
    final chips = <Widget>[];

    if (book.categories != null && book.categories!.isNotEmpty) {
      chips.add(
        _InfoChip(
          label: book.categories!.first.toUpperCase(),
          backgroundColor: const Color(0xFFEAE7E2),
        ),
      );
    }

    if (_isNewRelease()) {
      chips.add(
        const _InfoChip(label: 'NEW', backgroundColor: Color(0xFFDDE5FA)),
      );
    } else if (book.publishedYear != null) {
      chips.add(
        _InfoChip(
          label: '${book.publishedYear}',
          backgroundColor: const Color(0xFFDDE5FA),
        ),
      );
    }

    return chips;
  }

  bool _isNewRelease() {
    final year = book.publishedYear;
    if (year == null) {
      return false;
    }

    return year >= DateTime.now().year - 1;
  }
}

class _BookCover extends StatelessWidget {
  final String? imageUrl;

  const _BookCover({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      decoration: BoxDecoration(
        color: const Color(0xFFD89264),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 0.68,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Container(
                color: const Color(0xFFE7D4C4),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 38,
                  color: Color(0xFF7C6E63),
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFE7D4C4),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFFE7D4C4),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 38,
                    color: Color(0xFF7C6E63),
                  ),
                ),
              ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const _InfoChip({required this.label, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
          color: Color(0xFF66625E),
        ),
      ),
    );
  }
}
