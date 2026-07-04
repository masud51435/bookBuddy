import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_config.dart';
import '../../domain/entities/book_entity.dart';
import 'providers.dart';

// Pagination state
final pageProvider = StateProvider((ref) {
  ref.watch(searchQueryProvider);
  return 1;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final isSearchingProvider = StateProvider((ref) => false);

// Books list provider
final booksProvider = FutureProvider.autoDispose<List<BookEntity>>((ref) async {
  final page = ref.watch(pageProvider);
  final usecase = ref.watch(getBooksUsecaseProvider);

  final result = await usecase(page: page, pageSize: AppConfig.pageSize);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (books) => books,
  );
});

// Search results provider
final searchResultsProvider = FutureProvider.autoDispose<List<BookEntity>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  final page = ref.watch(pageProvider);
  final usecase = ref.watch(searchBooksUsecaseProvider);

  if (query.isEmpty) {
    return [];
  }

  final result = await usecase(
    query: query,
    page: page,
    pageSize: AppConfig.pageSize,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (books) => books,
  );
});

// Book details provider
final bookDetailsProvider = FutureProvider.autoDispose
    .family<BookEntity, String>((ref, bookId) async {
      final usecase = ref.watch(getBookDetailsUsecaseProvider);
      final result = await usecase(bookId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (book) => book,
      );
    });

// Favorites provider
final favoritesProvider = FutureProvider.autoDispose<List<BookEntity>>((
  ref,
) async {
  final usecase = ref.watch(getFavoritesUsecaseProvider);
  final result = await usecase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (books) => books,
  );
});

// Current books with search filter
final currentBooksProvider =
    Provider.autoDispose<AsyncValue<List<BookEntity>>>((ref) {
      final isSearching = ref.watch(isSearchingProvider);

      if (isSearching) {
        return ref.watch(searchResultsProvider);
      } else {
        return ref.watch(booksProvider);
      }
    });

// Toggle favorite provider
final toggleFavoriteProvider = Provider((ref) {
  return (BookEntity book) async {
    final result = book.isFavorite
        ? await ref.read(removeFavoriteUsecaseProvider)(book.id)
        : await ref.read(addFavoriteUsecaseProvider)(book.id);

    result.fold(
      (failure) => null,
      (_) {
        ref.invalidate(favoritesProvider);
        ref.invalidate(bookDetailsProvider(book.id));
        ref.invalidate(booksProvider);
        ref.invalidate(searchResultsProvider);
      },
    );
  };
});
