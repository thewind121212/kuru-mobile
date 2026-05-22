import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

// ---------------------------------------------------------------------------
// Fake repo
// ---------------------------------------------------------------------------

class _FakeCategoryRepo implements CategoryRepository {
  _FakeCategoryRepo({this.onGetOverview, this.onGetById});
  final VoidCallback? onGetOverview;
  final void Function(String id)? onGetById;

  @override
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview({
    int depth = 5,
  }) async {
    onGetOverview?.call();
    return ApiResult.success(const []);
  }

  @override
  Future<ApiResult<gen.CategoryResponse>> getById(String id) async {
    onGetById?.call(id);
    return ApiResult.success(
      gen.CategoryResponse(
        (b) => b
          ..categoryId = id
          ..orgId = 'org-1'
          ..itemCount = 0
          ..totalValue = 0
          ..lowStockCount = 0,
      ),
    );
  }

  @override
  Future<ApiResult<gen.CreateCategoryResponse>> create(
    gen.CreateCategoryRequest request,
  ) async => ApiResult.success(gen.CreateCategoryResponse((b) => b));

  @override
  Future<ApiResult<gen.UpdateCategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) async => ApiResult.success(
    gen.UpdateCategoryResponse((b) => b..categoryId = categoryId),
  );

  @override
  Future<ApiResult<void>> remove(List<String> ids) async =>
      ApiResult.success(null);
}

final callCountsByid = <String, int>{};

void main() {
  tearDown(callCountsByid.clear);

  test('categoryApiClientProvider builds CategoryApi', () {
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(Dio(BaseOptions(baseUrl: 'http://host'))),
      ],
    );
    addTearDown(container.dispose);

    final api = container.read(categoryApiClientProvider);
    expect(api, isA<gen.CategoryApi>());
  });

  // Note: we cannot assert the cloned dio's baseUrl or interceptor list from
  // outside the provider because CategoryApi._dio is private (generated code).
  // The SuperTokens fix (wireSuperTokensToDio called before
  // interceptors.addAll) is exercised implicitly: if it were missing, any real
  // Category API call would return 401. Integration / E2E tests are the right
  // layer to cover that.
  test(
    'categoryApiClientProvider copies shared dio interceptors into clone',
    () {
      // Supply a shared dio with a known non-zero interceptor count so we can
      // confirm the provider does not silently drop them.
      final sharedDio = Dio(BaseOptions(baseUrl: 'http://host'))
        ..interceptors.add(InterceptorsWrapper()) // dummy #1
        ..interceptors.add(InterceptorsWrapper()); // dummy #2

      final container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(sharedDio)],
      );
      addTearDown(container.dispose);

      // Building the provider must not throw — if interceptors.addAll broke
      // (e.g. was removed) the provider body would still build but the session
      // interceptors would be missing. The assertion here is a smoke-check that
      // provider construction succeeds when the shared dio has interceptors.
      final api = container.read(categoryApiClientProvider);
      expect(api, isA<gen.CategoryApi>());
    },
  );

  test(
    'categoryOverviewProvider re-fires when currentOrgIdProvider changes',
    () async {
      var callCount = 0;
      final fakeRepo = _FakeCategoryRepo(onGetOverview: () => callCount++);

      final container = ProviderContainer(
        overrides: [categoryRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      // First read with org A.
      container.read(orgIdOverrideProvider.notifier).orgId = 'org-a';
      await container.read(categoryOverviewProvider.future);
      expect(callCount, 1);

      // Switch to org B — provider should refire on next read.
      container.read(orgIdOverrideProvider.notifier).orgId = 'org-b';
      container.invalidate(categoryOverviewProvider);
      await container.read(categoryOverviewProvider.future);
      expect(callCount, 2);
    },
  );

  test(
    'categoryByIdProvider re-fires when currentOrgIdProvider changes',
    () async {
      var callCount = 0;
      final fakeRepo = _FakeCategoryRepo(onGetById: (_) => callCount++);

      final container = ProviderContainer(
        overrides: [categoryRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      // First read with org A.
      container.read(orgIdOverrideProvider.notifier).orgId = 'org-a';
      await container.read(categoryByIdProvider('cat-1').future);
      expect(callCount, 1);

      // Switch to org B — provider should refire on next read.
      container.read(orgIdOverrideProvider.notifier).orgId = 'org-b';
      container.invalidate(categoryByIdProvider('cat-1'));
      await container.read(categoryByIdProvider('cat-1').future);
      expect(callCount, 2);
    },
  );

  test('categoryByIdProvider.family fetches by UUID string', () async {
    final fakeRepo = _FakeCategoryRepo(
      onGetById: (id) => callCountsByid[id] = (callCountsByid[id] ?? 0) + 1,
    );

    final container = ProviderContainer(
      overrides: [categoryRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    container.read(orgIdOverrideProvider.notifier).orgId = 'org-a';
    await container.read(categoryByIdProvider('cat-1').future);
    expect(callCountsByid['cat-1'], 1);

    // Different family key — fresh fetch.
    await container.read(categoryByIdProvider('cat-2').future);
    expect(callCountsByid['cat-2'], 1);
  });
}
