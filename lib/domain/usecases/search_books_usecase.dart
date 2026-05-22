import '../entities/book_entity.dart';
import '../repositories/book_repository.dart';

class SearchBooksUsecase {
  final BookRepository repository;

  SearchBooksUsecase(this.repository);

  Future<Result<List<BookEntity>>> call({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    return repository.searchBooks(query: query, page: page, pageSize: pageSize);
  }
}
