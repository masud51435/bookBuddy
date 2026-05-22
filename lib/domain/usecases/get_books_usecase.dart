import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class GetBooksUsecase {
  final BookRepository repository;

  GetBooksUsecase(this.repository);

  Future<Result<List<BookEntity>>> call({
    required int page,
    required int pageSize,
  }) async {
    return repository.getBooks(page: page, pageSize: pageSize);
  }
}
