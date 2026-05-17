import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

/// Generated Category API client wired with our configured Dio.
///
/// The generated [gen.KuruCategoryApi] root class passes the provided [Dio]
/// directly to [gen.CategoryApi], so [basePathOverride] has no effect when a
/// pre-built dio is supplied. Instead, we clone the shared dioProvider dio
/// with baseUrl overridden to `${Env.apiBaseUrl}/api/v1` — keeping all
/// interceptors (SuperTokens, x-org-id, logging, error-mapping) intact while
/// scoping requests to the `/api/v1` prefix required by category endpoints
/// (e.g. `/category/CreateCategory` resolves to
/// `http://host/api/v1/category/CreateCategory`).
final categoryApiClientProvider = Provider<gen.CategoryApi>((ref) {
  final sharedDio = ref.watch(dioProvider);

  // Clone the shared dio so we can override baseUrl without mutating the
  // instance used by auth routes (`/auth/*` at host root).
  final categoryDio = Dio(
    sharedDio.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'),
  )..interceptors.addAll(sharedDio.interceptors);

  return gen.KuruCategoryApi(dio: categoryDio).getCategoryApi();
});
