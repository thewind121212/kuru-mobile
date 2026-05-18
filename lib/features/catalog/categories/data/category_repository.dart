import 'package:dio/dio.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;

/// Wraps the generated `CategoryApi` with DioException → ApiException
/// translation and `ApiResult<T>` returns.
///
/// Owns **no** UI state — callers (widgets / Riverpod providers) manage their
/// own loading flags.
///
/// Only read methods are exposed in Plan 1. Mutation methods (create, update,
/// remove) come in Plan 2.
///
/// ### Error extraction
///
/// The [_extract] helper first checks whether the [DioException] already
/// carries a typed [ApiException] attached by the error-mapping interceptor
/// (via `e.error`). If so it is returned as-is. Otherwise [mapDioError] is
/// called as a fallback — this path is hit in tests that construct raw
/// [DioException]s without going through the interceptor stack.
class CategoryRepository {
  CategoryRepository(this._api);
  final gen.CategoryApi _api;

  /// Fetches the flat category overview list up to [depth] levels deep.
  ///
  /// Returns [ApiSuccess] containing a (possibly empty) [List] of
  /// [gen.CategoryResponse], or [ApiFailure] with a typed [ApiException].
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview({
    int depth = 5,
  }) async {
    try {
      final res = await _api.getCategoryOverviewWithDepth(depth: depth);
      final overviews = res.data?.data.categoryOverviews?.toList() ?? const [];
      log.i(
        'GetCategoryOverviewWithDepth ← ${res.statusCode} '
        'count=${overviews.length}',
      );
      return ApiResult.success(overviews);
    } on DioException catch (e) {
      log.w('GetCategoryOverviewWithDepth failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Fetches a single category by its [categoryId].
  ///
  /// Returns [ApiSuccess]<[gen.CategoryResponse]> on success, or
  /// [ApiFailure] with a typed [ApiException]. Returns
  /// [ApiFailure]([UnknownException]) if the response body is null (should
  /// never happen against the real BE but guards deserialization failures).
  Future<ApiResult<gen.CategoryResponse>> getById(String categoryId) async {
    try {
      final res = await _api.getCategoryById(
        getCategoryByIdRequest: gen.GetCategoryByIdRequest(
          (b) => b..categoryId = categoryId,
        ),
      );
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from GetCategoryById'),
        );
      }
      log.i('GetCategoryById ← ${res.statusCode} id=${body.categoryId}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('GetCategoryById($categoryId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Creates a new category. The [request] must already have `name`,
  /// `layer`, and `status` set; mobile derives `layer` from context
  /// (root vs nested) — never lets the user pick it.
  ///
  /// Returns [ApiSuccess] with the newly-created category's ID (the BE
  /// echoes the generated UUID in [gen.CreateCategoryResponse]). On HTTP 400
  /// the `error.message` is surfaced verbatim through [BadRequestException]
  /// (per spec §6.2 — the BE writes user-readable validation messages).
  Future<ApiResult<gen.CreateCategoryResponse>> create(
    gen.CreateCategoryRequest request,
  ) async {
    try {
      final res = await _api.createCategory(createCategoryRequest: request);
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from CreateCategory'),
        );
      }
      log.i('CreateCategory ← ${res.statusCode} id=${body.categoryId}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('CreateCategory failed: ${e.message}');
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
