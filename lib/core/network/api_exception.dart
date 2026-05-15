sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  // ignore: no_runtimetype_tostring — safe in exception types for debugging
  String toString() => '$runtimeType: $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class TimeoutException extends ApiException {
  const TimeoutException(super.message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {this.code});
  final String? code;
}

class ServerException extends ApiException {
  const ServerException(super.message, {required this.statusCode});
  final int statusCode;
}

class UnknownException extends ApiException {
  const UnknownException(super.message);
}
