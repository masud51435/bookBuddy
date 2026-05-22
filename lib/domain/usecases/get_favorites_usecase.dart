import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetFavoritesUsecase {
  final BookRepository repository;

  GetFavoritesUsecase(this.repository);

  Future<Result<List<BookEntity>>> call() async {
    return repository.getFavorites();
  }
}
