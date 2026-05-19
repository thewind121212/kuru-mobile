import 'package:dio/dio.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;

/// Wraps the generated [gen.BrandApi] with DioException → ApiException
/// translation and `ApiResult<T>` returns.
///
/// Brand v1 is flat — no children, no slug, no logo. Form sends only `name`.
class BrandRepository {
  BrandRepository(this._api);
  final gen.BrandApi _api;

  static const int _overviewLimit = 200;

  /// Fetches the first page of brands (limit=200). Discards pagination meta —
  /// the list screen treats this as load-all and filters client-side. Re-evaluate
  /// when any real org passes ~150 brands.
  Future<ApiResult<List<gen.BrandOverviewItem>>> getOverview() async {
    try {
      final res = await _api.getBrandOverview(page: 1, limit: _overviewLimit);
      final list = res.data?.data.brands?.toList() ?? const [];
      log.i('GetBrandOverview ← ${res.statusCode} count=${list.length}');
      return ApiResult.success(list);
    } on DioException catch (e) {
      log.w('GetBrandOverview failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Fetches a single brand by id.
  Future<ApiResult<gen.BrandResponse>> getById(String brandId) async {
    try {
      final res = await _api.getBrandById(brandId: brandId);
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from GetBrandById'),
        );
      }
      log.i('GetBrandById ← ${res.statusCode} id=${body.id}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('GetBrandById($brandId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Creates a new brand. Returns the new `brandId`.
  ///
  /// HTTP 400 with `error.message = "Brand with this name already exists"` is
  /// surfaced via [BadRequestException] for the form to display verbatim.
  Future<ApiResult<String>> create({required String name}) async {
    try {
      final res = await _api.createBrand(
        createBrandRequest: gen.CreateBrandRequest((b) => b..name = name),
      );
      final body = res.data?.data;
      final id = body?.brandId;
      if (id == null) {
        return ApiResult.failure(
          const UnknownException('Empty brandId from CreateBrand'),
        );
      }
      log.i('CreateBrand ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreateBrand failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Updates an existing brand. Only `name` is editable in v1.
  Future<ApiResult<void>> update({
    required String brandId,
    required String name,
  }) async {
    try {
      final res = await _api.updateBrand(
        updateBrandRequest: gen.UpdateBrandRequest(
          (b) => b
            ..brandId = brandId
            ..name = name,
        ),
      );
      log.i('UpdateBrand ← ${res.statusCode} id=$brandId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('UpdateBrand($brandId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Soft-deletes a brand. BE may 400 with a user-readable reason
  /// (e.g. "Brand has products" if BE adds that rule); the verbatim
  /// message bubbles up through [BadRequestException] for callers
  /// to render in the delete-confirm SnackBar.
  Future<ApiResult<void>> remove(String brandId) async {
    try {
      final res = await _api.deleteBrand(
        deleteBrandRequest: gen.DeleteBrandRequest((b) => b..brandId = brandId),
      );
      log.i('DeleteBrand ← ${res.statusCode} id=$brandId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('DeleteBrand($brandId) failed: ${e.message}');
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
