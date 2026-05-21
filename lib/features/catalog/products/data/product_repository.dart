import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';

/// Hand-built request maps (per spec §3 — DTO wins over generated client).
class ProductRepository {
  ProductRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<ProductListPage>> getOverview({
    required ProductListFilter filter,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final q = <String, dynamic>{'page': page, 'limit': limit};
      if (filter.search != null && filter.search!.isNotEmpty) {
        q['searchString'] = filter.search;
      }
      if (filter.categoryId != null) q['categoryIds'] = [filter.categoryId];
      if (filter.brandId != null) q['brandIds'] = [filter.brandId];

      final res = await _dio.get<dynamic>(
        '/product/GetProductOverview',
        queryParameters: q,
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final items = (data['products'] as List<dynamic>)
          .map((e) => ProductSummary.fromJson(e as Map<String, dynamic>))
          .toList();
      log.i('GetProductOverview ← ${res.statusCode} count=${items.length}');
      return ApiResult.success(
        ProductListPage(
          items: items,
          page: page,
          limit: limit,
          totalProducts:
              (data['totalProducts'] as num?)?.toInt() ?? items.length,
        ),
      );
    } on DioException catch (e) {
      log.w('GetProductOverview failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<ProductDetail>> getById(String productId) async {
    try {
      final res = await _dio.get<dynamic>(
        '/product/GetProductById',
        queryParameters: {'productId': productId},
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      log.i('GetProductById ← ${res.statusCode} id=${data['id']}');
      return ApiResult.success(ProductDetail.fromJson(data));
    } on DioException catch (e) {
      log.w('GetProductById($productId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> create(CreateProductBody body) async {
    try {
      final res = await _dio.post<dynamic>(
        '/product/CreateProduct',
        data: body.toJson(),
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final id = data['productId'] as String?;
      if (id == null) {
        return ApiResult.failure(
          const UnknownException('Empty productId from CreateProduct'),
        );
      }
      log.i('CreateProduct ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreateProduct failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> uploadAvatar({
    required File file,
    required String productId,
    required String orgId,
  }) async {
    try {
      final form = FormData.fromMap(<String, dynamic>{
        'orgId': orgId,
        'productId': productId,
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });
      final res = await _dio.post<dynamic>(
        '/file/UploadProductAvatar',
        data: form,
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final key = data['key'] as String?;
      if (key == null) {
        return ApiResult.failure(
          const UnknownException('Missing key from UploadProductAvatar'),
        );
      }
      log.i('UploadProductAvatar ← ${res.statusCode} id=$productId');
      return ApiResult.success(key);
    } on DioException catch (e) {
      log.w('UploadProductAvatar($productId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> updateInfo(UpdateProductInfoBody body) async {
    try {
      final res = await _dio.patch<dynamic>(
        '/product/UpdateProductInfo',
        data: body.toJson(),
      );
      log.i('UpdateProductInfo ← ${res.statusCode} id=${body.productId}');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('UpdateProductInfo(${body.productId}) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Converts a [DioException] into a typed [ApiException].
  ///
  /// Prefers any [ApiException] already attached to `e.error` by the
  /// error-mapping interceptor — those carry exact status-code semantics.
  /// Falls back to [mapDioError] for raw exceptions (e.g. from unit tests).
  ApiException _extract(DioException e) {
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }
}
