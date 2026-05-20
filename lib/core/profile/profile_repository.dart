import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';

class ProfileRepository {
  ProfileRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<void>> updateProfile({
    String? name,
    String? avatarStyle,
    String? avatarSeed,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/UpdateProfile',
        data: <String, dynamic>{
          if (name != null) 'name': name,
          if (avatarStyle != null) 'avatarStyle': avatarStyle,
          if (avatarSeed != null) 'avatarSeed': avatarSeed,
        },
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'UpdateProfile failed'));
    }
  }

  Future<ApiResult<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/ChangePassword',
        data: <String, dynamic>{
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'ChangePassword failed'));
    }
  }

  Future<ApiResult<bool>> verifyPassword(String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/VerifyPassword',
        data: <String, dynamic>{'password': password},
      );
      final verified =
          (res.data?['data'] as Map<String, dynamic>?)?['verified'] as bool? ??
          false;
      return ApiResult.success(verified);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'VerifyPassword failed'));
    }
  }

  Future<ApiResult<SecurityStatus>> getSecurityStatus() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/GetSecurityStatus',
        data: <String, dynamic>{},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(SecurityStatus.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'GetSecurityStatus failed'));
    }
  }

  Future<ApiResult<void>> disableTotp({required String password}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/DisableTotp',
        data: <String, dynamic>{'password': password},
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'DisableTotp failed'));
    }
  }

  Future<ApiResult<List<String>>> regenerateRecoveryCodes({
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/RegenerateRecoveryCodes',
        data: <String, dynamic>{'password': password},
      );
      final codes =
          (res.data?['data'] as Map<String, dynamic>?)?['codes']
              as List<dynamic>?;
      return ApiResult.success((codes ?? const <dynamic>[]).cast<String>());
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'RegenerateRecoveryCodes failed'));
    }
  }

  Future<ApiResult<String>> uploadAvatar({
    required File file,
    required String userId,
  }) async {
    try {
      final form = FormData.fromMap(<String, dynamic>{
        'userId': userId,
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/UploadUserAvatar',
        data: form,
      );
      final key =
          (res.data?['data'] as Map<String, dynamic>?)?['key'] as String?;
      if (key == null) {
        return ApiResult.failure(
          const ServerException(
            'Missing key in upload response',
            statusCode: 201,
          ),
        );
      }
      return ApiResult.success(key);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'UploadUserAvatar failed'));
    }
  }

  ApiException _extract(DioException e, String fallback) {
    final mapped = e.error;
    return mapped is ApiException ? mapped : UnknownException(fallback);
  }
}
