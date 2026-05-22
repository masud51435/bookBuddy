import '../repositories/book_repository.dart';

class RemoveFavoriteUsecase {
  final BookRepository repository;

  RemoveFavoriteUsecase(this.repository);

  Future<Result<void>> call(String bookId) async {
    return repository.removeFavorite(bookId);
  }
}
