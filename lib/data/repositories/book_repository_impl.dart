import '../datasources/remote/google_books_remote_datasource_impl.dart';
import '../datasources/local/favorites_local_datasource_impl.dart';
import '../models/book_model.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final GoogleBooksRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSourceImpl localDataSource;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<BookEntity>>> getBooks({
    required int page,
    required int pageSize,
  }) async {
    try {
      final responses = await remoteDataSource.getBooks(
        page: page,
        pageSize: pageSize,
      );

      final favorites = await localDataSource.getFavorites();
      final favSet = favorites.map((e) => e['id'] as String).toSet();

      final books = responses
          .expand((response) => response.items ?? [])
          .map<BookEntity>((model) => model.toEntity(isFavorite: favSet.contains(model.id)))
          .toList();

      return Success(books);
    } on ServerException catch (e) {
      Logger.logError('Server error: ${e.message}', e);
      return ResultFailure(ServerFailure(e.message, statusCode: e.statusCode));
    } on TimeoutException catch (e) {
      Logger.logError('Timeout error: ${e.message}', e);
      return ResultFailure(TimeoutFailure(e.message));
    } on NetworkException catch (e) {
      Logger.logError('Network error: ${e.message}', e);
      return ResultFailure(NetworkFailure(e.message));
    } catch (e) {
      Logger.logError('Unexpected error in getBooks', e);
      return ResultFailure(UnknownFailure('Failed to fetch books: $e'));
    }
  }

  @override
  Future<Result<BookEntity>> getBookDetails(String bookId) async {
    try {
      final bookModel = await remoteDataSource.getBookDetails(bookId);

      final isFav = await localDataSource.isFavorite(bookId);
      return Success(bookModel.toEntity(isFavorite: isFav));
    } on ServerException catch (e) {
      return _tryGetLocalBook(bookId, ServerFailure(e.message, statusCode: e.statusCode));
    } on TimeoutException catch (e) {
      return _tryGetLocalBook(bookId, TimeoutFailure(e.message));
    } on NetworkException catch (e) {
      return _tryGetLocalBook(bookId, NetworkFailure(e.message));
    } catch (e) {
      return _tryGetLocalBook(bookId, UnknownFailure('Failed to fetch book details: $e'));
    }
  }

  Future<Result<BookEntity>> _tryGetLocalBook(String bookId, Failure failure) async {
    try {
      final isFav = await localDataSource.isFavorite(bookId);
      if (isFav) {
        final favorites = await localDataSource.getFavorites();
        final bookMap = favorites.firstWhere((map) => map['id'] == bookId);
        return Success(BookModel.fromJson(bookMap).toEntity(isFavorite: true));
      }
    } catch (_) {
      // Ignore local fetch error and return original failure
    }
    return ResultFailure(failure);
  }

  @override
  Future<Result<List<BookEntity>>> searchBooks({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await remoteDataSource.searchBooks(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      final favorites = await localDataSource.getFavorites();
      final favSet = favorites.map((e) => e['id'] as String).toSet();

      final books = (response.items ?? [])
          .map((model) => model.toEntity(isFavorite: favSet.contains(model.id)))
          .toList();

      return Success(books);
    } on ServerException catch (e) {
      return ResultFailure(ServerFailure(e.message, statusCode: e.statusCode));
    } on TimeoutException catch (e) {
      return ResultFailure(TimeoutFailure(e.message));
    } on NetworkException catch (e) {
      return ResultFailure(NetworkFailure(e.message));
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to search books: $e'));
    }
  }

  @override
  Future<Result<void>> addFavorite(BookEntity book) async {
    try {
      final model = BookModel.fromEntity(book);
      await localDataSource.addFavorite(model.toJson());
      return const Success(null);
    } on CacheException catch (e) {
      return ResultFailure(CacheFailure(e.message));
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to add favorite: $e'));
    }
  }

  @override
  Future<Result<void>> removeFavorite(String bookId) async {
    try {
      await localDataSource.removeFavorite(bookId);
      return const Success(null);
    } on CacheException catch (e) {
      return ResultFailure(CacheFailure(e.message));
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to remove favorite: $e'));
    }
  }

  @override
  Future<Result<List<BookEntity>>> getFavorites() async {
    try {
      final favoriteMaps = await localDataSource.getFavorites();
      final books = favoriteMaps
          .map((map) => BookModel.fromJson(map).toEntity(isFavorite: true))
          .toList();

      return Success(books);
    } on CacheException catch (e) {
      return ResultFailure(CacheFailure(e.message));
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to get favorites: $e'));
    }
  }

  @override
  Future<Result<bool>> isFavorite(String bookId) async {
    try {
      final result = await localDataSource.isFavorite(bookId);
      return Success(result);
    } on CacheException catch (e) {
      return ResultFailure(CacheFailure(e.message));
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to check favorite status: $e'));
    }
  }
}
