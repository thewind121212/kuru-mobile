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

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
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

/// Raised by the dio org-id interceptor when an authenticated request fires
/// before `currentOrgIdProvider` resolves a value. Surfaces as a fast
/// rejection instead of letting the request hit BE without `x-org-id` (which
/// returns a 401 that supertokens then chases through a stalled refresh
/// chain, surfacing in the UI as an opaque `TimeoutException`).
class OrgNotReadyException extends ApiException {
  const OrgNotReadyException()
    : super('Org context not ready — try again in a moment');
}
