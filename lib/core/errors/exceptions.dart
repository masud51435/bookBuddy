abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class ServerException extends AppException {
  final int? statusCode;
  ServerException(super.message, {this.statusCode});
}

class ParseException extends AppException {
  ParseException(super.message);
}

class TimeoutException extends AppException {
  TimeoutException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}
