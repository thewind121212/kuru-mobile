import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';

/// Dio configured with `${apiBaseUrl}/api/v1` base — same pattern as
/// brand/category api clients in this catalog.
final productDioProvider = Provider<Dio>((ref) {
  final shared = ref.watch(dioProvider);
  final d = Dio(shared.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'));
  wireSuperTokensToDio(d);
  d.interceptors.addAll(shared.interceptors);
  return d;
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(productDioProvider));
});

class ProductListNotifier
    extends FamilyAsyncNotifier<ProductListPage, ProductListFilter> {
  static const int _limit = 50;
  int _page = 1;
  bool _isLoadingMore = false;
  List<ProductSummary> _accum = [];

  @override
  Future<ProductListPage> build(ProductListFilter arg) async {
    ref.watch(currentOrgIdProvider);
    _page = 1;
    _isLoadingMore = false;
    _accum = [];
    final repo = ref.watch(productRepositoryProvider);
    final result = await repo.getOverview(filter: arg, page: _page).unwrap();
    _accum = result.items;
    return result;
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (_isLoadingMore || current == null || !current.hasMore) return;
    _isLoadingMore = true;
    state = const AsyncValue<ProductListPage>.loading().copyWithPrevious(state);
    try {
      final repo = ref.read(productRepositoryProvider);
      final next = await repo
          .getOverview(filter: arg, page: _page + 1)
          .unwrap();
      _page += 1;
      _accum = [..._accum, ...next.items];
      state = AsyncValue.data(
        ProductListPage(
          items: _accum,
          page: _page,
          limit: _limit,
          totalProducts: next.totalProducts,
        ),
      );
    } on Object catch (e, st) {
      state = AsyncValue<ProductListPage>.error(e, st).copyWithPrevious(state);
    } finally {
      _isLoadingMore = false;
    }
  }
}

final productListProvider =
    AsyncNotifierProviderFamily<
      ProductListNotifier,
      ProductListPage,
      ProductListFilter
    >(ProductListNotifier.new);

final productByIdProvider = FutureProvider.family<ProductDetail, String>((
  ref,
  id,
) async {
  ref.watch(currentOrgIdProvider);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getById(id).unwrap();
});

final canWriteProductsProvider = Provider<bool>((ref) {
  final permsAsync = ref.watch(myPermissionsProvider);
  return permsAsync.maybeWhen(
    data: (p) => p.orgPerms.contains('product.write'),
    orElse: () => false,
  );
});
