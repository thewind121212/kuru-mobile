import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';

/// Generated Brand API client wired with our configured dio.
///
/// Same pattern as `categoryApiClientProvider`: clone the shared dio so we can
/// set the baseUrl to `${apiBaseUrl}/api/v1` without mutating the host instance
/// used by `/auth/*` routes. Re-install SuperTokens via its extension method
/// (it is NOT in `sharedDio.interceptors` so `addAll` below does not bring it)
/// and copy the manual interceptors (x-org-id, logging, error-mapping).
final brandApiClientProvider = Provider<gen.BrandApi>((ref) {
  final sharedDio = ref.watch(dioProvider);
  final brandDio = Dio(
    sharedDio.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'),
  );
  wireSuperTokensToDio(brandDio);
  brandDio.interceptors.addAll(sharedDio.interceptors);
  return gen.KuruBrandApi(dio: brandDio).getBrandApi();
});

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepository(ref.watch(brandApiClientProvider));
});

/// Flat list of brands for the current org. Watches [currentOrgIdProvider] so
/// org switches auto-invalidate the cache.
final brandOverviewProvider = FutureProvider<List<gen.BrandOverviewItem>>((
  ref,
) async {
  ref.watch(currentOrgIdProvider);
  final repo = ref.watch(brandRepositoryProvider);
  return repo.getOverview().unwrap();
});
