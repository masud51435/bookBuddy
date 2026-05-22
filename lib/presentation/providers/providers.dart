import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/favorites_local_datasource_impl.dart';
import '../../data/datasources/remote/google_books_remote_datasource_impl.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../../domain/usecases/get_book_details_usecase.dart';
import '../../domain/usecases/search_books_usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';

// Datasources
final dioClientProvider = Provider((ref) => DioClient());

final favoritesLocalDataSourceProvider = Provider((ref) {
  return FavoritesLocalDataSourceImpl();
});

final googleBooksRemoteDataSourceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GoogleBooksRemoteDataSourceImpl(dioClient);
});

// Repository
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final remoteDataSource = ref.watch(googleBooksRemoteDataSourceProvider);
  final localDataSource = ref.watch(favoritesLocalDataSourceProvider);
  return BookRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// Use Cases
final getBooksUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return GetBooksUsecase(repository);
});

final getBookDetailsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return GetBookDetailsUsecase(repository);
});

final searchBooksUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return SearchBooksUsecase(repository);
});

final addFavoriteUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return AddFavoriteUsecase(repository);
});

final removeFavoriteUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return RemoveFavoriteUsecase(repository);
});

final getFavoritesUsecaseProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return GetFavoritesUsecase(repository);
});
