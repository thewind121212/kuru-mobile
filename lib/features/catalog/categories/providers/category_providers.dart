import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

/// Generated Category API client wired with our configured Dio.
///
/// The generated [gen.KuruCategoryApi] root class passes the provided [Dio]
/// directly to [gen.CategoryApi], so `basePathOverride` has no effect when a
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
  );

  // MUST be first — same order as dioProvider in dio_client.dart.
  // SuperTokens is installed via an extension method, NOT via
  // dio.interceptors.add(), so copying sharedDio.interceptors below does NOT
  // bring it along. Omitting this call would leave categoryDio with no session
  // token attachment and every authenticated Category call would return 401.
  wireSuperTokensToDio(categoryDio);

  // Copy the remaining manual interceptors (x-org-id, logging, error-mapping).
  categoryDio.interceptors.addAll(sharedDio.interceptors);

  return gen.KuruCategoryApi(dio: categoryDio).getCategoryApi();
});
