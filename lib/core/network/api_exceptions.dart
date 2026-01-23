// Custom API Exceptions
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}
