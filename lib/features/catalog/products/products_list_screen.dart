// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_card.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_filter_bar.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_filter_sheet.dart';

String _productRouteBase(BuildContext context) {
  final path = GoRouterState.of(context).uri.path;
  return path.startsWith('/products') ? '/products' : '/catalog/products';
}

class ProductsListScreen extends ConsumerStatefulWidget {
  const ProductsListScreen({super.key});

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;
  ProductListFilter _filter = const ProductListFilter();
  Map<String, String> _categoryLabels = const {};
  Map<String, String> _brandLabels = const {};
  Map<String, String> _warehouseLabels = const {};
  Map<String, String> _variantLabels = const {};

  static final _money = NumberFormat.decimalPattern('vi_VN');

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final search = _searchCtrl.text.trim();
      setState(
        () =>
            _filter = _filter.copyWith(search: search.isEmpty ? null : search),
      );
    });
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 600) {
      ref.read(productListProvider(_filter).notifier).loadMore();
    }
  }

  Future<void> _openFilters() async {
    final catsFuture = ref.read(categoryOverviewProvider.future);
    final brandsFuture = ref.read(brandOverviewProvider.future);
    final variantAttributesFuture = ref.read(
      variantAttributeOverviewProvider.future,
    );
    final warehousesFuture = ref.read(productWarehouseOptionsProvider.future);
    final storeOverviewFuture = ref.read(
      productListProvider(const ProductListFilter()).future,
    );
    var cats = ref.read(categoryOverviewProvider).valueOrNull ?? const [];
    var brands = ref.read(brandOverviewProvider).valueOrNull ?? const [];
    var variantAttributes =
        ref.read(variantAttributeOverviewProvider).valueOrNull ?? const [];
    var warehouses =
        ref.read(productWarehouseOptionsProvider).valueOrNull ?? const [];
    var storeMaxPrice = ref
        .read(productListProvider(const ProductListFilter()))
        .valueOrNull
        ?.maxSellPrice
        .toDouble();
    Object? loadError;

    try {
      cats = await catsFuture;
    } on Object catch (e) {
      loadError = e;
    }

    try {
      brands = await brandsFuture;
    } on Object catch (e) {
      loadError ??= e;
    }

    try {
      variantAttributes = await variantAttributesFuture;
    } on Object catch (e) {
      loadError ??= e;
    }

    try {
      warehouses = await warehousesFuture;
    } on Object catch (e) {
      loadError ??= e;
    }

    try {
      storeMaxPrice = (await storeOverviewFuture).maxSellPrice.toDouble();
    } on Object catch (e) {
      loadError ??= e;
    }

    if (!mounted) return;
    if (loadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tải đủ dữ liệu bộ lọc: $loadError')),
      );
    }

    final result = await showProductFilterSheet(
      context: context,
      initial: _filter,
      categories: cats
          .where((c) => c.categoryId != null && c.name != null)
          .map(
            (c) => ProductFilterOption(
              id: c.categoryId!,
              name: c.name!,
              subtitle: c.parentName,
            ),
          )
          .toList(),
      brands: brands
          .map((b) => ProductFilterOption(id: b.id, name: b.name))
          .toList(),
      warehouses: warehouses
          .map(
            (warehouse) => ProductFilterOption(
              id: warehouse.warehouseId,
              name: warehouse.name,
              subtitle: warehouse.address,
            ),
          )
          .toList(),
      variantAttributes: variantAttributes
          .map(
            (attribute) => ProductVariantFilterAttribute(
              id: attribute.id,
              name: attribute.name,
              values: attribute.values
                  .map(
                    (value) =>
                        ProductFilterOption(id: value.id, name: value.value),
                  )
                  .toList(),
            ),
          )
          .toList(),
      priceCeiling: _priceCeiling(storeMaxPrice),
    );
    if (!mounted || result == null) return;
    setState(() {
      _filter = result.filter;
      _categoryLabels = result.categoryLabels;
      _brandLabels = result.brandLabels;
      _warehouseLabels = result.warehouseLabels;
      _variantLabels = result.variantLabels;
    });
  }

  void _clearFilters() {
    setState(() {
      _filter = _filter.clearFilters();
      _categoryLabels = const {};
      _brandLabels = const {};
      _warehouseLabels = const {};
      _variantLabels = const {};
    });
  }

  void _removeCategory(String id) => setState(() {
    _filter = _filter.copyWith(
      categoryIds: _filter.categoryIds.where((v) => v != id).toList(),
    );
    _categoryLabels = {..._categoryLabels}..remove(id);
  });

  void _removeBrand(String id) => setState(() {
    _filter = _filter.copyWith(
      brandIds: _filter.brandIds.where((v) => v != id).toList(),
    );
    _brandLabels = {..._brandLabels}..remove(id);
  });

  void _removeWarehouse(String id) => setState(() {
    _filter = _filter.copyWith(
      warehouseIds: _filter.warehouseIds.where((v) => v != id).toList(),
    );
    _warehouseLabels = {..._warehouseLabels}..remove(id);
  });

  void _clearPrice() => setState(() {
    _filter = _filter.copyWith(minPrice: null, maxPrice: null);
  });

  void _removeVariantValue(String attributeId, String valueId) => setState(() {
    _filter = _filter.copyWith(
      attributeFilters: [
        for (final filter in _filter.attributeFilters)
          if (filter.attributeId == attributeId)
            filter.copyWith(
              valueIds: filter.valueIds.where((id) => id != valueId).toList(),
            )
          else
            filter,
      ].where((filter) => filter.valueIds.isNotEmpty).toList(),
    );
    _variantLabels = {..._variantLabels}..remove('$attributeId:$valueId');
  });

  List<ProductFilterChipData> _activeChips() {
    return [
      for (final id in _filter.categoryIds)
        ProductFilterChipData(
          label: 'DM: ${_categoryLabels[id] ?? id}',
          onRemove: () => _removeCategory(id),
        ),
      for (final id in _filter.brandIds)
        ProductFilterChipData(
          label: 'TH: ${_brandLabels[id] ?? id}',
          onRemove: () => _removeBrand(id),
        ),
      for (final id in _filter.warehouseIds)
        ProductFilterChipData(
          label: 'Kho: ${_warehouseLabels[id] ?? id}',
          onRemove: () => _removeWarehouse(id),
        ),
      for (final filter in _filter.attributeFilters)
        for (final valueId in filter.valueIds)
          ProductFilterChipData(
            label: _variantLabels['${filter.attributeId}:$valueId'] ?? valueId,
            onRemove: () => _removeVariantValue(filter.attributeId, valueId),
          ),
      if (_filter.minPrice != null || _filter.maxPrice != null)
        ProductFilterChipData(label: _priceLabel(), onRemove: _clearPrice),
    ];
  }

  String _priceLabel() {
    final min = _filter.minPrice;
    final max = _filter.maxPrice;
    if (min != null && max != null) {
      return '${_money.format(min)}-${_money.format(max)}đ';
    }
    if (min != null) return 'Từ ${_money.format(min)}đ';
    return 'Đến ${_money.format(max)}đ';
  }

  double _priceCeiling([double? storeMaxPrice]) {
    var ceiling =
        storeMaxPrice ??
        ref
            .read(productListProvider(const ProductListFilter()))
            .valueOrNull
            ?.maxSellPrice
            .toDouble() ??
        ref
            .read(productListProvider(_filter))
            .valueOrNull
            ?.maxSellPrice
            .toDouble() ??
        1.0;
    final maxFilter = _filter.maxPrice?.toDouble() ?? 0;
    if (maxFilter > ceiling) ceiling = maxFilter;
    return _roundPriceCeiling(ceiling);
  }

  static double _roundPriceCeiling(double value) {
    if (value <= 0) return 1;
    if (value <= 1000000) return value;
    return ((value / 1000000).ceil() * 1000000).toDouble();
  }

  Future<void> _createProduct() async {
    unawaited(context.push('${_productRouteBase(context)}/create'));
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final canWrite = ref.watch(canWriteProductsProvider);
    final async = ref.watch(productListProvider(_filter));
    ref
      ..watch(categoryOverviewProvider)
      ..watch(brandOverviewProvider)
      ..watch(variantAttributeOverviewProvider)
      ..watch(productWarehouseOptionsProvider)
      ..watch(productListProvider(const ProductListFilter()));

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(productListProvider(_filter)),
          child: CustomScrollView(
            controller: _scrollCtrl,
            cacheExtent: 900,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 18, 4),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Sản phẩm',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      if (canWrite)
                        FilledButton.icon(
                          onPressed: _createProduct,
                          icon: const Icon(TablerIcons.plus),
                          label: const Text('Tạo'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                  child: Text(
                    async.maybeWhen(
                      data: (p) => '${p.totalProducts} sản phẩm',
                      orElse: () => 'Đang tải…',
                    ),
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ProductFilterBar(
                  searchController: _searchCtrl,
                  activeCount: _filter.activeCount,
                  activeChips: _activeChips(),
                  onFilterTap: _openFilters,
                  onClearAll: _clearFilters,
                ),
              ),
              async.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('Không tải được danh sách: $e')),
                  ),
                ),
                data: (page) {
                  if (page.items.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            const Icon(
                              TablerIcons.package,
                              size: 56,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có sản phẩm',
                              style: TextStyle(
                                fontSize: 16,
                                color: c.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tạo sản phẩm đầu tiên để bắt đầu.',
                              style: TextStyle(
                                fontSize: 13,
                                color: c.textMuted,
                              ),
                            ),
                            if (canWrite) ...[
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: _createProduct,
                                child: const Text('Tạo sản phẩm'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }
                  return _ProductMasonrySliver(
                    items: page.items,
                    hasMore: page.hasMore,
                    onProductTap: (item) => context.push(
                      '${_productRouteBase(context)}/${item.id}',
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductMasonrySliver extends StatelessWidget {
  const _ProductMasonrySliver({
    required this.items,
    required this.hasMore,
    required this.onProductTap,
  });

  final List<ProductSummary> items;
  final bool hasMore;
  final ValueChanged<ProductSummary> onProductTap;

  static const _horizontalPadding = 6.0;
  static const _gap = 6.0;

  @override
  Widget build(BuildContext context) => SliverMainAxisGroup(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: _columnCountFor(MediaQuery.sizeOf(context).width),
          mainAxisSpacing: _gap,
          crossAxisSpacing: _gap,
          childCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ProductCard(
              key: ValueKey(item.id),
              product: item,
              onTap: () => onProductTap(item),
            );
          },
        ),
      ),
      if (hasMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ],
  );

  static int _columnCountFor(double width) => switch (width) {
    < 340 => 1,
    >= 700 => 3,
    _ => 2,
  };
}
