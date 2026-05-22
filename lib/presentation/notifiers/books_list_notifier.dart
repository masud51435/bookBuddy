import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../../domain/entities/book_entity.dart';
import '../providers/providers.dart';

class BooksListState {
  final List<BookEntity> books;
  final String query;
  final String? errorMessage;
  final int nextPage;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;

  BooksListState({
    required this.books,
    required this.query,
    this.errorMessage,
    required this.nextPage,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.hasMore,
  });

  BooksListState copyWith({
    List<BookEntity>? books,
    String? query,
    String? errorMessage,
    int? nextPage,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return BooksListState(
      books: books ?? this.books,
      query: query ?? this.query,
      errorMessage: errorMessage,
      nextPage: nextPage ?? this.nextPage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class BooksListNotifier extends StateNotifier<BooksListState> {
  BooksListNotifier(this._ref)
    : super(
        BooksListState(
          books: [],
          query: '',
          errorMessage: null,
          nextPage: 1,
          isInitialLoading: true,
          isLoadingMore: false,
          hasMore: true,
        ),
      );

  final StateNotifierProviderRef _ref;
  Timer? _searchDebounce;

  Future<void> loadBooks({bool reset = false}) async {
    if (state.isLoadingMore || (!reset && !state.hasMore)) {
      return;
    }

    final page = reset ? 1 : state.nextPage;

    state = state.copyWith(
      isInitialLoading: reset ? true : state.isInitialLoading,
      isLoadingMore: reset ? false : true,
      errorMessage: reset ? null : state.errorMessage,
      hasMore: reset ? true : state.hasMore,
    );

    final result = state.query.trim().isEmpty
        ? await _ref.read(getBooksUsecaseProvider)(
            page: page,
            pageSize: AppConfig.pageSize,
          )
        : await _ref.read(searchBooksUsecaseProvider)(
            query: state.query.trim(),
            page: page,
            pageSize: AppConfig.pageSize,
          );

    result.fold(
      (failure) {
        state = state.copyWith(
          books: reset ? [] : state.books,
          errorMessage: failure.message,
          isInitialLoading: false,
          isLoadingMore: false,
        );
      },
      (books) {
        state = state.copyWith(
          books: reset ? books : _mergeBooks(state.books, books),
          nextPage: page + 1,
          hasMore: books.length >= AppConfig.pageSize,
          errorMessage: null,
          isInitialLoading: false,
          isLoadingMore: false,
        );
      },
    );
  }

  List<BookEntity> _mergeBooks(
    List<BookEntity> currentBooks,
    List<BookEntity> newBooks,
  ) {
    final mergedBooks = [...currentBooks];
    final existingIds = currentBooks.map((book) => book.id).toSet();

    for (final book in newBooks) {
      if (!existingIds.contains(book.id)) {
        mergedBooks.add(book);
      }
    }

    return mergedBooks;
  }

  void handleSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (value.trim() == state.query.trim()) {
        return;
      }

      state = state.copyWith(query: value);
      loadBooks(reset: true);
    });
  }

  void clearSearch() {
    handleSearch('');
  }

  Future<void> toggleFavorite(BookEntity book) async {
    final result = book.isFavorite
        ? await _ref.read(removeFavoriteUsecaseProvider)(book.id)
        : await _ref.read(addFavoriteUsecaseProvider)(book.id);

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: 'Failed to update: ${failure.message}',
        );
      },
      (_) {
        state = state.copyWith(
          books: state.books
              .map(
                (item) => item.id == book.id
                    ? item.copyWith(isFavorite: !item.isFavorite)
                    : item,
              )
              .toList(),
        );
      },
    );
  }

  void handleScroll(double pixels, double maxExtent) {
    if (state.isInitialLoading || state.isLoadingMore) {
      return;
    }

    const paginationThreshold = 240.0;
    if (pixels >= maxExtent - paginationThreshold) {
      loadBooks();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
