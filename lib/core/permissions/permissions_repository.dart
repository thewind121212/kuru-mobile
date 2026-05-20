import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

class PermissionsRepository {
  PermissionsRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<ResolvedPermissions>> getMyPermissions(String orgId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/v1/store/GetMyPermissions',
        queryParameters: <String, dynamic>{'orgId': orgId},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(ResolvedPermissions.fromJson(data));
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(
        mapped is ApiException
            ? mapped
            : const UnknownException('GetMyPermissions failed'),
      );
    }
  }
}
