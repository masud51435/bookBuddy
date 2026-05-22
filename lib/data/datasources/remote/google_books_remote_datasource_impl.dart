import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/logger.dart';
import '../../../config/app_config.dart';
import '../../models/book_model.dart';
import '../../models/search_response_model.dart';

abstract class GoogleBooksRemoteDataSource {
  Future<List<SearchResponseModel>> getBooks({
    required int page,
    required int pageSize,
  });

  Future<SearchResponseModel> searchBooks({
    required String query,
    required int page,
    required int pageSize,
  });

  Future<BookModel> getBookDetails(String bookId);
}

class GoogleBooksRemoteDataSourceImpl implements GoogleBooksRemoteDataSource {
  final DioClient dioClient;

  GoogleBooksRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<SearchResponseModel>> getBooks({
    required int page,
    required int pageSize,
  }) async {
    try {
      Logger.logDebug('Fetching books from Google Books API');

      const String query = 'books';
      final startIndex = (page - 1) * pageSize;

      final response = await dioClient.get(
        '/volumes',
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': pageSize,
          'key': AppConfig.googleBooksApiKey,
        },
      );

      if (response.statusCode == 200) {
        final model = SearchResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return [model];
      } else {
        throw ServerException(
          'Failed to load books',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<SearchResponseModel> searchBooks({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      Logger.logDebug('Searching books with query: $query');

      final startIndex = (page - 1) * pageSize;

      final response = await dioClient.get(
        '/volumes',
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': pageSize,
          'key': AppConfig.googleBooksApiKey,
        },
      );

      if (response.statusCode == 200) {
        return SearchResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          'Failed to search books',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<BookModel> getBookDetails(String bookId) async {
    try {
      Logger.logDebug('Fetching book details for id: $bookId');

      final response = await dioClient.get(
        '/volumes/$bookId',
        queryParameters: {'key': AppConfig.googleBooksApiKey},
      );

      if (response.statusCode == 200) {
        return BookModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Failed to load book details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  AppException _handleDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        TimeoutException('Connection timed out. Please try again.'),
      DioExceptionType.badResponse => ServerException(
        e.response?.data?['error']?['message'] ?? 'Server error occurred',
        statusCode: e.response?.statusCode,
      ),
      DioExceptionType.connectionError =>
        NetworkException('No internet connection. Please check your network.'),
      _ => NetworkException('Please check your internet connection and try again.'),
    };
  }
}
