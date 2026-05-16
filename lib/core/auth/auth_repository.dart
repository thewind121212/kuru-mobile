import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  /// SuperTokens EmailPassword sign-in. Path is `/auth/signin` at the host
  /// root — kuru BE mounts the SuperTokens middleware before `/api/v1`.
  Future<ApiResult<void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/signin',
        data: {
          'formFields': [
            {'id': 'email', 'value': email},
            {'id': 'password', 'value': password},
          ],
        },
      );
      final status = res.data?['status'] as String? ?? 'UNKNOWN';
      if (status == 'OK') return ApiResult.success(null);
      if (status == 'WRONG_CREDENTIALS_ERROR') {
        return ApiResult.failure(
          const UnauthorizedException('WRONG_CREDENTIALS'),
        );
      }
      return ApiResult.failure(BadRequestException(status));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  /// REST API endpoint — note the `/api/v1` prefix. The dio baseUrl is the
  /// host root, so every REST call writes the full path here.
  Future<ApiResult<UserInfo>> getUserInfo() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/GetUserInfo',
        data: <String, dynamic>{},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(UserInfo.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  Future<void> signOut() async {
    await SuperTokens.signOut();
  }

  /// SuperTokens emailpassword sign-up.
  Future<ApiResult<void>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/signup',
        data: {
          'formFields': [
            {'id': 'email', 'value': email},
            {'id': 'password', 'value': password},
            // SuperTokens accepts arbitrary extra form fields; the BE schema
            // for sign-up passes them through as user metadata.
            {'id': 'name', 'value': fullName},
          ],
        },
      );
      final status = res.data?['status'] as String? ?? 'UNKNOWN';
      if (status == 'OK') return ApiResult.success(null);
      if (status == 'FIELD_ERROR') {
        return ApiResult.failure(
          BadRequestException(status, code: 'FIELD_ERROR'),
        );
      }
      if (status == 'EMAIL_ALREADY_EXISTS_ERROR') {
        return ApiResult.failure(
          BadRequestException(status, code: 'EMAIL_EXISTS'),
        );
      }
      return ApiResult.failure(BadRequestException(status));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  /// Create a Store (the multi-tenant root entity). Returns the new store id.
  Future<ApiResult<String>> createStore({required String name}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/CreateStore',
        data: {'name': name},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      final id = data?['storeId'] as String?;
      if (id == null) {
        return ApiResult.failure(
          const ServerException('Missing storeId', statusCode: 200),
        );
      }
      return ApiResult.success(id);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  /// Create a Storage row (kuru's "branch") inside a store. Best-effort —
  /// failure is non-fatal; caller may continue with just the store.
  Future<ApiResult<String>> createStorage({required String name}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/storage/CreateStore',
        data: {'name': name},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      final id = data?['storageId'] as String? ?? data?['id'] as String?;
      if (id == null) {
        return ApiResult.failure(
          const ServerException('Missing storageId', statusCode: 200),
        );
      }
      return ApiResult.success(id);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  /// Verify a 6-digit TOTP code mid-login. On OK the BE marks the session's
  /// `mfaCompleted` flag — subsequent `getUserInfo` calls return
  /// `totpEnabled=false`, so the bootstrap provider transitions from
  /// `BootstrapMfaPending` to `BootstrapAuthed` on next invalidate.
  ///
  /// BE semantics observed against kuru:
  /// - HTTP 200 with `data.verified=true` → ok
  /// - HTTP 400 with error code (not RATE_LIMITED) → wrong code (same as the
  ///   web FE's `catch → setOtpError('wrongCode')` path)
  /// - HTTP 429 with code `RATE_LIMITED` → rate limited
  /// - Anything else → real failure (network, 5xx)
  Future<ApiResult<TotpVerifyResult>> verifyTotpCode({
    required String code,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/VerifyTotpCode',
        data: {'code': code},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      final verified = data?['verified'] as bool? ?? false;
      return ApiResult.success(
        verified
            ? const TotpVerifyResult.ok()
            : const TotpVerifyResult.wrongCode(),
      );
    } on DioException catch (e) {
      return _interpretMfaError(e);
    }
  }

  /// Consume one recovery code. Same session-marking behavior as TOTP verify
  /// and the same 400 → wrong-code mapping.
  Future<ApiResult<TotpVerifyResult>> useRecoveryCode({
    required String code,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/UseRecoveryCode',
        data: {'code': code},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      final ok = (data['verified'] as bool?) ?? true;
      return ApiResult.success(
        ok ? const TotpVerifyResult.ok() : const TotpVerifyResult.wrongCode(),
      );
    } on DioException catch (e) {
      return _interpretMfaError(e);
    }
  }

  /// Shared mapping for both verifyTotpCode and useRecoveryCode error paths.
  /// The BE returns 400 for wrong codes (Auth.tsx web FE treats any error
  /// during verify as a wrong code), 429 for rate-limit, others as real
  /// network/server failures.
  ///
  /// One observed BE quirk: when SuperTokens' `Session.getSession()` throws
  /// inside the route (e.g. access token expired and no refresh attempted),
  /// the express error handler turns it into a 500 with the literal message
  /// "Session does not exist anymore". That's a BE bug — it should be a 401
  /// so the dio SuperTokens interceptor can refresh transparently. Until the
  /// BE is patched, we map the message to `TotpVerifyResult.sessionExpired`
  /// so the screen can sign the user out and route to /login.
  ApiResult<TotpVerifyResult> _interpretMfaError(DioException e) {
    final err = _extract(e);
    if (err is BadRequestException) {
      if (err.code == 'RATE_LIMITED') {
        return ApiResult.success(const TotpVerifyResult.rateLimited());
      }
      return ApiResult.success(const TotpVerifyResult.wrongCode());
    }
    if (err is UnauthorizedException) {
      return ApiResult.success(const TotpVerifyResult.sessionExpired());
    }
    if (err is ServerException) {
      final body = e.response?.data;
      final raw = body is Map ? body.toString() : (body?.toString() ?? '');
      if (raw.toLowerCase().contains('session does not exist') ||
          raw.toLowerCase().contains('try refresh token')) {
        return ApiResult.success(const TotpVerifyResult.sessionExpired());
      }
    }
    return ApiResult.failure(err);
  }

  ApiException _extract(DioException e) {
    final mapped = e.error;
    return mapped is ApiException
        ? mapped
        : const UnknownException('Unexpected error');
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(dioProvider)),
);

/// Outcome of a TOTP or recovery-code verification attempt that the screen
/// reacts to. `ok` advances the user past MFA; `wrongCode` keeps them on the
/// screen with an inline error; `rateLimited` shows a longer-cooldown toast;
/// `sessionExpired` means the BE no longer recognises our session — caller
/// should sign out and route to /login.
sealed class TotpVerifyResult {
  const TotpVerifyResult();
  const factory TotpVerifyResult.ok() = TotpOk;
  const factory TotpVerifyResult.wrongCode() = TotpWrongCode;
  const factory TotpVerifyResult.rateLimited() = TotpRateLimited;
  const factory TotpVerifyResult.sessionExpired() = TotpSessionExpired;
}

final class TotpOk extends TotpVerifyResult {
  const TotpOk();
}

final class TotpWrongCode extends TotpVerifyResult {
  const TotpWrongCode();
}

final class TotpRateLimited extends TotpVerifyResult {
  const TotpRateLimited();
}

final class TotpSessionExpired extends TotpVerifyResult {
  const TotpSessionExpired();
}
