import '../repositories/book_repository.dart';

class AddFavoriteUsecase {
  final BookRepository repository;

  AddFavoriteUsecase(this.repository);

  Future<Result<void>> call(String bookId) async {
    return repository.addFavorite(bookId);
  }
}
