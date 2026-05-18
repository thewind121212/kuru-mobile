import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';

/// Provides a configured dio instance. baseUrl is the kuru host root —
/// this dio is used for both SuperTokens auth routes (`/auth/*` at root) and
/// the REST API routes (`/api/v1/*`); each caller includes its own prefix.
/// The SuperTokens interceptor is wired separately by Task B5.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl, // root, e.g. http://localhost:9190
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  // MUST be first — token attach + refresh wraps the rest.
  wireSuperTokensToDio(dio);

  dio.interceptors.add(_OrgIdInterceptor(ref));
  dio.interceptors.add(_LoggingInterceptor());
  dio.interceptors.add(_ErrorMappingInterceptor());

  return dio;
});

/// Reads currentOrgIdProvider lazily and stamps `x-org-id` on every request
/// once an org is selected.
class _OrgIdInterceptor extends Interceptor {
  _OrgIdInterceptor(this._ref);
  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read the live current-org value. The provider is defined in
    // auth_providers.dart; we import it lazily via the ref.
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId != null) options.headers['x-org-id'] = orgId;
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler h) {
    log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    h.next(response);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    log.w('× ${e.response?.statusCode ?? '???'} ${e.requestOptions.uri}: '
        '${e.message}');
    handler.next(e);
  }
}

class _ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    final mapped = mapDioError(e);
    handler.reject(
      DioException(
        requestOptions: e.requestOptions,
        error: mapped,
        response: e.response,
        type: e.type,
      ),
    );
  }
}

/// Converts a DioException into our typed ApiException. Exposed for unit tests.
ApiException mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException('Request timed out');
    case DioExceptionType.connectionError:
      return const NetworkException('No network connection');
    case DioExceptionType.cancel:
      return const UnknownException('Request cancelled');
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      final msg = _extractMessage(e.response?.data) ?? 'HTTP $status';
      if (status == 401) {
        return UnauthorizedException(msg);
      }
      if (status == 403) {
        return ForbiddenException(msg);
      }
      if (status >= 400 && status < 500) {
        return BadRequestException(msg, code: _extractCode(e.response?.data));
      }
      return ServerException(msg, statusCode: status);
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnknownException(e.message ?? 'Unknown error');
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
    final error = data['error'] as Map<String, dynamic>;
    return error['message']?.toString();
  }
  return null;
}

String? _extractCode(dynamic data) {
  if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
    final error = data['error'] as Map<String, dynamic>;
    return error['code']?.toString();
  }
  return null;
}
