import 'dart:convert';
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
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
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
      if (filter.categoryIds.isNotEmpty) q['categoryIds'] = filter.categoryIds;
      if (filter.brandIds.isNotEmpty) q['brandIds'] = filter.brandIds;
      if (filter.warehouseIds.isNotEmpty) {
        q['warehouseIds'] = filter.warehouseIds;
      }
      if (filter.attributeFilters.isNotEmpty) {
        q['attributeFilters'] = filter.attributeFilters.map((filter) {
          return jsonEncode(<String, dynamic>{
            'attributeId': filter.attributeId,
            'valueIds': filter.valueIds,
          });
        }).toList();
      }
      if (filter.minPrice != null) q['minPrice'] = filter.minPrice;
      if (filter.maxPrice != null) q['maxPrice'] = filter.maxPrice;

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
          maxSellPrice: (data['maxSellPrice'] as num?) ?? 0,
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

  Future<ApiResult<void>> adjustStock({
    required String productId,
    required List<ProductStockAdjustment> adjustments,
    String note = 'Mobile stock set',
  }) async {
    if (adjustments.isEmpty) return ApiResult.success(null);
    try {
      final res = await _dio.patch<dynamic>(
        '/product/AdjustProductStock',
        data: <String, dynamic>{
          'productId': productId,
          'reason': 'STOCK_TAKE',
          'note': note,
          'stocks': adjustments.map((a) => a.toJson()).toList(),
        },
      );
      log.i(
        'AdjustProductStock ← ${res.statusCode} id=$productId '
        'count=${adjustments.length}',
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('AdjustProductStock($productId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> updateUmos({
    required String productId,
    List<ProductUmoUpsert> upserts = const [],
    List<String> removeIds = const [],
  }) async {
    if (upserts.isEmpty && removeIds.isEmpty) return ApiResult.success(null);
    try {
      final res = await _dio.patch<dynamic>(
        '/product/UpdateProductUmos',
        data: <String, dynamic>{
          'productId': productId,
          if (upserts.isNotEmpty)
            'upsertUmos': upserts.map((u) => u.toJson()).toList(),
          if (removeIds.isNotEmpty) 'removeUmoIds': removeIds,
        },
      );
      log.i(
        'UpdateProductUmos ← ${res.statusCode} id=$productId '
        'upsert=${upserts.length} remove=${removeIds.length}',
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('UpdateProductUmos($productId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<List<ProductVariant>>> saveVariants({
    required String productId,
    List<ProductVariantUpsert> variants = const [],
    List<String> deleteVariantIds = const [],
  }) async {
    if (variants.isEmpty && deleteVariantIds.isEmpty) {
      return ApiResult.success(const <ProductVariant>[]);
    }
    try {
      final res = await _dio.patch<dynamic>(
        '/product/SaveProductVariants',
        data: <String, dynamic>{
          'productId': productId,
          'variants': variants.map((v) => v.toJson()).toList(),
          'deleteVariantIds': deleteVariantIds,
        },
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final parsed = (data['variants'] as List<dynamic>? ?? const [])
          .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .where((variant) => variant.id.isNotEmpty)
          .toList();
      log.i(
        'SaveProductVariants ← ${res.statusCode} id=$productId '
        'upsert=${variants.length} delete=${deleteVariantIds.length}',
      );
      return ApiResult.success(parsed);
    } on DioException catch (e) {
      log.w('SaveProductVariants($productId) failed: ${e.message}');
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

class ProductVariantUpsert {
  const ProductVariantUpsert({
    required this.name,
    this.id,
    this.sellPrice,
    this.importPrice,
    this.exportPrice,
    this.attributeValueIds = const [],
  });

  final String? id;
  final String name;
  final num? sellPrice;
  final num? importPrice;
  final num? exportPrice;
  final List<String> attributeValueIds;

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'name': name,
    if (sellPrice != null) 'sellPrice': sellPrice,
    if (importPrice != null) 'importPrice': importPrice,
    if (exportPrice != null) 'exportPrice': exportPrice,
    if (attributeValueIds.isNotEmpty) 'attributeValueIds': attributeValueIds,
  };
}

class ProductStockAdjustment {
  const ProductStockAdjustment({
    required this.warehouseId,
    required this.quantity,
  });

  final String warehouseId;
  final num quantity;

  Map<String, dynamic> toJson() => {
    'warehouseId': warehouseId,
    'quantity': quantity,
  };
}

class ProductUmoUpsert {
  const ProductUmoUpsert({
    required this.label,
    required this.ratio,
    this.id,
    this.sellPrice,
    this.barcode,
  });

  final String? id;
  final String label;
  final int ratio;
  final num? sellPrice;
  final String? barcode;

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'label': label,
    'ratio': ratio,
    if (sellPrice != null) 'sellPrice': sellPrice,
    if (barcode != null && barcode!.isNotEmpty) 'barcode': barcode,
  };
}
