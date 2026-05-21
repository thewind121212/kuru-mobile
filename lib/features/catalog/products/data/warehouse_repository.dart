import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';

class WarehouseRepository {
  const WarehouseRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<ProductWarehouseOption>>> getBranches() async {
    try {
      final res = await _dio.get<dynamic>('/storage/GetAllBranches');
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final branches = (data['branches'] as List<dynamic>? ?? const [])
          .map(
            (branch) =>
                ProductWarehouseOption.fromJson(branch as Map<String, dynamic>),
          )
          .where(
            (branch) => branch.warehouseId.isNotEmpty && branch.name.isNotEmpty,
          )
          .toList();
      log.i('GetAllBranches ← ${res.statusCode} count=${branches.length}');
      return ApiResult.success(branches);
    } on DioException catch (e) {
      log.w('GetAllBranches failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  ApiException _extract(DioException e) {
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }
}
