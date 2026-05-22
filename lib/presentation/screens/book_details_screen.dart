import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/book_entity.dart';
import '../providers/book_providers.dart';
import '../providers/providers.dart';
import '../widgets/common_widgets.dart';
import '../widgets/shimmer_loading.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool? _favoriteOverride;

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookDetailsProvider(widget.bookId));

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bgCard,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        title: const Text(
          'Book Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
      body: bookAsync.when(
        data: (book) {
          final displayBook = book.copyWith(
            isFavorite: _favoriteOverride ?? book.isFavorite,
          );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BookHero(imageUrl: displayBook.imageUrl),
                      Transform.translate(
                        offset: const Offset(0, -38),
                        child: _BookInfoCard(
                          book: displayBook,
                          onFavoriteTap: () {
                            _toggleFavorite(displayBook);
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SectionTitle(title: 'Synopsis'),
                      const SizedBox(height: 14),
                      _SynopsisText(
                        text: _buildSynopsis(displayBook.description),
                      ),
                      const SizedBox(height: 34),
                      _SectionTitle(title: 'Reader Insights'),
                      const SizedBox(height: 14),
                      _InsightCard(book: displayBook),
                      const SizedBox(height: 18),
                      _EditionDetailsCard(book: displayBook),
                      const SizedBox(height: 32),
                      _BottomActionCard(book: displayBook),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const ShimmerBookDetails(),
        error: (error, stack) => AppErrorWidget(
          message: 'Failed to load book details',
          onRetry: () {
            ref.invalidate(bookDetailsProvider(widget.bookId));
          },
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(BookEntity book) async {
    setState(() {
      _favoriteOverride = !book.isFavorite;
    });

    if (book.isFavorite) {
      await ref.read(removeFavoriteUsecaseProvider)(book.id);
    } else {
      await ref.read(addFavoriteUsecaseProvider)(book.id);
    }

    if (!mounted) {
      return;
    }

    ref.invalidate(bookDetailsProvider(widget.bookId));
    ref.invalidate(currentBooksProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          book.isFavorite ? 'Removed from favorites' : 'Added to favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _buildSynopsis(String? description) {
    if (description != null && description.trim().isNotEmpty) {
      return description.trim();
    }

    return 'No synopsis available for this title.';
  }
}

class _BookHero extends StatelessWidget {
  final String? imageUrl;

  const _BookHero({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 360,
      margin: const EdgeInsets.symmetric(horizontal: 34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6E1BC), Color(0xFFD3AE83)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 46),
        child: imageUrl == null || imageUrl!.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF163245),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 56,
                    color: Color(0xFFE6D3B1),
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF163245),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE6D3B1)),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF163245),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 56,
                      color: Color(0xFFE6D3B1),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _BookInfoCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onFavoriteTap;

  const _BookInfoCard({required this.book, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlay.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (book.subtitle != null && book.subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              book.subtitle!.trim(),
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'by  '),
                TextSpan(
                  text: book.authors.isEmpty
                      ? 'Unknown author'
                      : book.authors.join(', '),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildCategoryChips(book),
                ),
              ),
              const SizedBox(width: 12),
              if (book.averageRating != null)
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book.averageRating!.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: 'FIRST PUBLISHED',
                  value: _formatPublishedDate(book),
                ),
              ),
              Expanded(
                child: _MetaItem(
                  label: 'PAGES',
                  value: book.pageCount?.toString() ?? 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: 'LANGUAGE',
                  value: _formatLanguage(book.language),
                ),
              ),
              Expanded(
                child: _MetaItem(
                  label: 'PUBLISHER',
                  value: _formatPublisher(book.publisher),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onFavoriteTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: Icon(
                book.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 20,
              ),
              label: Text(
                book.isFavorite ? 'IN FAVORITES' : 'ADD TO FAVORITES',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryChips(BookEntity book) {
    final categories = book.categories ?? [];
    if (categories.isEmpty) {
      return const [];
    }

    return categories
        .take(2)
        .map((category) => _CategoryChip(label: category))
        .toList();
  }

  String _formatLanguage(String? language) {
    if (language == null || language.isEmpty) {
      return 'N/A';
    }

    if (language.length <= 2) {
      return language.toUpperCase() == 'EN'
          ? 'English'
          : language.toUpperCase();
    }

    return '${language[0].toUpperCase()}${language.substring(1)}';
  }

  String _formatPublisher(String? publisher) {
    if (publisher == null || publisher.trim().isEmpty) {
      return 'N/A';
    }

    return publisher.trim();
  }

  String _formatPublishedDate(BookEntity book) {
    if (book.publishedDate != null && book.publishedDate!.trim().isNotEmpty) {
      return book.publishedDate!.trim();
    }

    if (book.publishedYear != null) {
      return book.publishedYear!.toString();
    }

    return 'N/A';
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SynopsisText extends StatelessWidget {
  final String text;

  const _SynopsisText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.7,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final BookEntity book;

  const _InsightCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final headline = _buildHeadline(book);
    final supportingText = _buildSupportingText(book);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: const TextStyle(
              fontSize: 22,
              height: 1,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            supportingText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _buildHeadline(BookEntity book) {
    if (book.averageRating != null && book.ratingsCount != null) {
      return '${book.averageRating!.toStringAsFixed(1)}/5';
    }

    if (book.averageRating != null) {
      return '${book.averageRating!.toStringAsFixed(1)} rating';
    }

    if (book.ratingsCount != null) {
      return '${book.ratingsCount} ratings';
    }

    if (book.pageCount != null) {
      return '${book.pageCount} pages';
    }

    if (book.publishedYear != null) {
      return '${book.publishedYear}';
    }

    return 'Book Info';
  }

  String _buildSupportingText(BookEntity book) {
    if (book.averageRating != null && book.ratingsCount != null) {
      return 'Based on ${book.ratingsCount} reader ratings on Google Books.';
    }

    if (book.averageRating != null) {
      return 'Average reader rating available for this title.';
    }

    if (book.ratingsCount != null) {
      return '${book.ratingsCount} readers have rated this title.';
    }

    if (book.pageCount != null) {
      return 'A full-length read with ${book.pageCount} pages in this edition.';
    }

    if (book.publishedYear != null) {
      return 'Originally published in ${book.publishedYear}.';
    }

    return 'Additional reader insights are not available for this title.';
  }
}

class _EditionDetailsCard extends StatelessWidget {
  final BookEntity book;

  const _EditionDetailsCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edition Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _buildSummary(book),
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFFD4E0F0),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _DarkInfoPill(
                label: 'Print Type',
                value: _formatPrintType(book.printType),
              ),
              _DarkInfoPill(
                label: 'Preview',
                value: _hasLink(book.previewLink) ? 'Available' : 'Unavailable',
              ),
              _DarkInfoPill(
                label: 'More Info',
                value: _hasLink(book.infoLink) ? 'Available' : 'Unavailable',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSummary(BookEntity book) {
    final parts = <String>[];

    if (book.publisher != null && book.publisher!.trim().isNotEmpty) {
      parts.add('Published by ${book.publisher!.trim()}');
    }

    if (book.publishedDate != null && book.publishedDate!.trim().isNotEmpty) {
      parts.add('Released on ${book.publishedDate!.trim()}');
    }

    if (book.printType != null && book.printType!.trim().isNotEmpty) {
      parts.add('Format: ${_formatPrintType(book.printType)}');
    }

    if (parts.isEmpty) {
      return 'This title has limited edition details available from Google Books.';
    }

    return '${parts.join('. ')}.';
  }

  String _formatPrintType(String? printType) {
    if (printType == null || printType.trim().isEmpty) {
      return 'N/A';
    }

    final value = printType.trim().toLowerCase();
    if (value == 'book') {
      return 'Book';
    }

    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  bool _hasLink(String? url) {
    return url != null && url.trim().isNotEmpty;
  }
}

class _BottomActionCard extends StatelessWidget {
  final BookEntity book;

  const _BottomActionCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final availabilityTitle = _buildAvailabilityTitle(book);
    final availabilityValue = _buildAvailabilityValue(book);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlay.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  availabilityTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  availabilityValue,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildAvailabilityTitle(BookEntity book) {
    if (book.previewLink != null && book.previewLink!.trim().isNotEmpty) {
      return 'Preview available on';
    }

    if (book.infoLink != null && book.infoLink!.trim().isNotEmpty) {
      return 'More info on';
    }

    if (book.publisher != null && book.publisher!.trim().isNotEmpty) {
      return 'Published by';
    }

    if (book.categories != null && book.categories!.isNotEmpty) {
      return 'Category';
    }

    return 'Book details';
  }

  String _buildAvailabilityValue(BookEntity book) {
    if (book.previewLink != null && book.previewLink!.trim().isNotEmpty) {
      return 'Google Books';
    }

    if (book.infoLink != null && book.infoLink!.trim().isNotEmpty) {
      return 'Google Books';
    }

    if (book.publisher != null && book.publisher!.trim().isNotEmpty) {
      return book.publisher!.trim();
    }

    if (book.categories != null && book.categories!.isNotEmpty) {
      return book.categories!.first;
    }

    return 'Google Books';
  }
}

class _DarkInfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _DarkInfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB5C5D9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
