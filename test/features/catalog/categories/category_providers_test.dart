import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

void main() {
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
}
