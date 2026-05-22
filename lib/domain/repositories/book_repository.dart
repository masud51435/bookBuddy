import '../../core/errors/failures.dart' as f;
import '../entities/book_entity.dart';

sealed class Result<T> {
  const Result();

  R fold<R>(R Function(f.Failure) onFailure, R Function(T) onSuccess) =>
      switch (this) {
        Success(value: final v) => onSuccess(v),
        ResultFailure(failure: final fai) => onFailure(fai),
      };

  Result<R> map<R>(R Function(T) f) => fold(
    (fai) => ResultFailure(fai),
    (v) => Success(f(v)),
  );
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class ResultFailure<T> extends Result<T> {
  final f.Failure failure;
  const ResultFailure(this.failure);
}

abstract class BookRepository {
  Future<Result<List<BookEntity>>> getBooks({
    required int page,
    required int pageSize,
  });

  Future<Result<BookEntity>> getBookDetails(String bookId);

  Future<Result<List<BookEntity>>> searchBooks({
    required String query,
    required int page,
    required int pageSize,
  });

  Future<Result<void>> addFavorite(String bookId);

  Future<Result<void>> removeFavorite(String bookId);

  Future<Result<List<BookEntity>>> getFavorites();

  Future<Result<bool>> isFavorite(String bookId);
}
