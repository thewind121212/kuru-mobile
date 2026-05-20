import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

class StoreSettings {
  const StoreSettings({required this.timezone, required this.name});
  final String timezone;
  final String name;
}

class StoreSettingsRepository {
  StoreSettingsRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<StoreSettings>> getStoreSettings() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/GetStoreSettings',
        data: <String, dynamic>{},
      );
      final d = res.data?['data'] as Map<String, dynamic>?;
      if (d == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(
        StoreSettings(
          timezone: d['timezone'] as String? ?? '',
          name: d['name'] as String? ?? '',
        ),
      );
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(
        mapped is ApiException
            ? mapped
            : const UnknownException('GetStoreSettings failed'),
      );
    }
  }

  Future<ApiResult<void>> updateStoreSettings({
    required String timezone,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/UpdateStoreSettings',
        data: <String, dynamic>{'timezone': timezone},
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(
        mapped is ApiException
            ? mapped
            : const UnknownException('UpdateStoreSettings failed'),
      );
    }
  }
}

final storeSettingsRepositoryProvider = Provider<StoreSettingsRepository>(
  (ref) => StoreSettingsRepository(ref.read(dioProvider)),
);
