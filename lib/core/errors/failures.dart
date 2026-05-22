sealed class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  ServerFailure(super.message, {this.statusCode});
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class ParseFailure extends Failure {
  ParseFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class TimeoutFailure extends Failure {
  TimeoutFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
