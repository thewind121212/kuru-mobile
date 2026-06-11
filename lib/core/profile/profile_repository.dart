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

  Future<ApiResult<TotpDeviceSetup>> createTotpDevice({
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/CreateTotpDevice',
        data: <String, dynamic>{'password': password},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(TotpDeviceSetup.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'CreateTotpDevice failed'));
    }
  }

  Future<ApiResult<TotpDeviceVerification>> verifyTotpDevice({
    required String deviceName,
    required String code,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/VerifyTotpDevice',
        data: <String, dynamic>{'deviceName': deviceName, 'code': code},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(TotpDeviceVerification.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'VerifyTotpDevice failed'));
    }
  }

  Future<ApiResult<void>> disableTotp({
    required String password,
    required String totpCode,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/DisableTotp',
        data: <String, dynamic>{'password': password, 'totpCode': totpCode},
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
      final data = res.data?['data'] as Map<String, dynamic>?;
      return ApiResult.success(_readStringList(data?['codes']));
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

  List<String> _readStringList(Object? value) {
    if (value is! List) return const <String>[];
    return value.whereType<String>().toList(growable: false);
  }
}

class TotpDeviceSetup {
  const TotpDeviceSetup({
    required this.deviceName,
    required this.secret,
    required this.qrCodeString,
  });

  final String deviceName;
  final String secret;
  final String qrCodeString;

  factory TotpDeviceSetup.fromJson(Map<String, dynamic> json) {
    return TotpDeviceSetup(
      deviceName: json['deviceName'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      qrCodeString: json['qrCodeString'] as String? ?? '',
    );
  }
}

class TotpDeviceVerification {
  const TotpDeviceVerification({
    required this.verified,
    required this.recoveryCodes,
  });

  final bool verified;
  final List<String> recoveryCodes;

  factory TotpDeviceVerification.fromJson(Map<String, dynamic> json) {
    final codes = json['recoveryCodes'];
    return TotpDeviceVerification(
      verified: json['verified'] as bool? ?? false,
      recoveryCodes: codes is List
          ? codes.whereType<String>().toList(growable: false)
          : const <String>[],
    );
  }
}
