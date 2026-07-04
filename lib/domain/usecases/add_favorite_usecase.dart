import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class AddFavoriteUsecase {
  final BookRepository repository;

  AddFavoriteUsecase(this.repository);

  Future<Result<void>> call(BookEntity book) async {
    return repository.addFavorite(book);
  }
}
