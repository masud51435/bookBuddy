import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBookDetailsUsecase {
  final BookRepository repository;

  GetBookDetailsUsecase(this.repository);

  Future<Result<BookEntity>> call(String bookId) async {
    return repository.getBookDetails(bookId);
  }
}
