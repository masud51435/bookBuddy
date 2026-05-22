import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/book_entity.dart';
import '../providers/book_providers.dart';
import '../providers/providers.dart';
import '../widgets/common_widgets.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: ValueListenableBuilder<Box<String>>(
        valueListenable: Hive.box<String>('favorites').listenable(),
        builder: (context, favoriteBox, _) {
          final favoriteIds = favoriteBox.values.toList().reversed.toList();

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _FavoritesHeader()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
                  child: _FavoritesIntro(count: favoriteIds.length),
                ),
              ),
              if (favoriteIds.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyWidget(
                    message: 'No favorite books yet. Start adding some!',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.64,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final bookId = favoriteIds[index];
                      return _FavoriteBookTile(bookId: bookId);
                    }, childCount: favoriteIds.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  const _FavoritesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              size: 30,
              color: AppColors.primary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'BookBuddy',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 25,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesIntro extends StatelessWidget {
  final int count;

  const _FavoritesIntro({required this.count});

  @override
  Widget build(BuildContext context) {
    final suffix = count == 1 ? 'book' : 'books';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 28,
            height: 1.05,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You have $count favorite $suffix',
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _FavoriteBookTile extends ConsumerWidget {
  final String bookId;

  const _FavoriteBookTile({required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailsProvider(bookId));

    return bookAsync.when(
      data: (book) {
        return _FavoriteBookCard(
          book: book,
          onTap: () => context.push('/book-details', extra: book.id),
          onRemoveTap: () async {
            await ref.read(removeFavoriteUsecaseProvider)(book.id);
            ref.invalidate(bookDetailsProvider(book.id));

            if (!context.mounted) {
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
      loading: () => const _FavoriteCardLoading(),
      error: (error, stack) => _FavoriteCardError(bookId: bookId),
    );
  }
}

class _FavoriteBookCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onTap;
  final VoidCallback onRemoveTap;

  const _FavoriteBookCard({
    required this.book,
    required this.onTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(18),
      elevation: 1.5,
      shadowColor: AppColors.overlay.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: _FavoriteCover(imageUrl: book.imageUrl),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: onRemoveTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: AppColors.favorite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                book.authors.isEmpty
                    ? 'UNKNOWN AUTHOR'
                    : book.authors.join(', ').toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteCover extends StatelessWidget {
  final String? imageUrl;

  const _FavoriteCover({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 42,
            color: AppColors.secondary,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: AppColors.secondary.withValues(alpha: 0.15),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.secondary.withValues(alpha: 0.15),
          child: const Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: 42,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteCardLoading extends StatelessWidget {
  const _FavoriteCardLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 18,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.skeleton,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: 88,
            decoration: BoxDecoration(
              color: AppColors.skeleton,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCardError extends StatelessWidget {
  final String bookId;

  const _FavoriteCardError({required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 32,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 10),
          const Text(
            'Could not load book',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bookId,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
