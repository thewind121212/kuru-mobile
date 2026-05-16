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
