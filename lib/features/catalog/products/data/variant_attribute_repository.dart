import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/models/product_variant_attribute.dart';

class VariantAttributeRepository {
  const VariantAttributeRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<ProductVariantAttribute>>> getOverview() async {
    try {
      final res = await _dio.get<dynamic>(
        '/variantattribute/GetVariantAttributes',
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final attributes = (data['attributes'] as List<dynamic>? ?? const [])
          .map(
            (attribute) => ProductVariantAttribute.fromJson(
              attribute as Map<String, dynamic>,
            ),
          )
          .where(
            (attribute) =>
                attribute.id.isNotEmpty &&
                attribute.name.isNotEmpty &&
                attribute.values.isNotEmpty,
          )
          .toList();
      log.i(
        'GetVariantAttributes ← ${res.statusCode} count=${attributes.length}',
      );
      return ApiResult.success(attributes);
    } on DioException catch (e) {
      log.w('GetVariantAttributes failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  ApiException _extract(DioException e) {
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }
}
