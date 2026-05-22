import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../notifiers/books_list_notifier.dart';
import '../providers/books_list_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/common_widgets.dart';
import '../widgets/search_bar.dart';
import '../widgets/shimmer_loading.dart';

class BooksListScreen extends ConsumerStatefulWidget {
  const BooksListScreen({super.key});

  @override
  ConsumerState<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends ConsumerState<BooksListScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(booksListNotifierProvider.notifier).loadBooks(reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    ref
        .read(booksListNotifierProvider.notifier)
        .handleScroll(position.pixels, position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(booksListNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            ref.read(booksListNotifierProvider.notifier).loadBooks(reset: true),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _BooksHeader()),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                controller: _searchController,
                onSearch: (value) => ref
                    .read(booksListNotifierProvider.notifier)
                    .handleSearch(value),
                onClear: () =>
                    ref.read(booksListNotifierProvider.notifier).clearSearch(),
                hintText: 'Filter by title or author...',
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
                fillColor: AppColors.bgSecondary,
                borderColor: AppColors.borderLight,
                borderRadius: 12,
              ),
            ),
            ..._buildContentSlivers(context, state),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContentSlivers(BuildContext context, BooksListState state) {
    if (state.isInitialLoading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ShimmerBookCard(),
              childCount: 6,
            ),
          ),
        ),
      ];
    }

    // Only show full-screen error if we have no data
    if (state.errorMessage != null && state.books.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppErrorWidget(
            message: state.errorMessage!,
            onRetry: () =>
                ref.read(booksListNotifierProvider.notifier).loadBooks(reset: true),
          ),
        ),
      ];
    }

    if (state.books.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyWidget(
            message: state.query.trim().isEmpty
                ? 'No books available right now.'
                : 'No books found for your search.',
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == state.books.length) {
              return _buildPaginationFooter(state);
            }

            final book = state.books[index];
            return BookCard(
              book: book,
              margin: const EdgeInsets.only(bottom: 18, left: 8, right: 8),
              onTap: () => context.push('/book-details', extra: book.id),
              onFavoriteTap: () => ref
                  .read(booksListNotifierProvider.notifier)
                  .toggleFavorite(book),
            );
          }, childCount: state.books.length + 1),
        ),
      ),
    ];
  }

  Widget _buildPaginationFooter(BooksListState state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.only(top: 12, bottom: 15),
        child: _PaginationLoadingView(),
      );
    }

    if (state.errorMessage != null && state.books.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () =>
                  ref.read(booksListNotifierProvider.notifier).loadBooks(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (!state.hasMore) {
      return const SizedBox(height: 12);
    }

    return const SizedBox.shrink();
  }
}

class _BooksHeader extends StatelessWidget {
  const _BooksHeader();

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

class _PaginationLoadingView extends StatelessWidget {
  const _PaginationLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Loading more titles...',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
