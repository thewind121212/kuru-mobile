// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/category_brand_picker_sheet.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/create_edit_product_sheet.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_card.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_filter_bar.dart';

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
  String? _categoryLabel;
  String? _brandLabel;

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
      setState(() => _filter = _filter.copyWith(search: _searchCtrl.text));
    });
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 600) {
      ref.read(productListProvider(_filter).notifier).loadMore();
    }
  }

  Future<void> _pickCategory() async {
    final cats = ref.read(categoryOverviewProvider).valueOrNull ?? const [];
    final picked = await showCategoryBrandPickerSheet(
      context: context,
      title: 'Chọn danh mục',
      items: cats
          .map((c) => PickerItem(id: c.categoryId ?? '', name: c.name ?? ''))
          .toList(),
      selectedId: _filter.categoryId,
    );
    if (!mounted) return;
    setState(() {
      _filter = _filter.copyWith(categoryId: picked);
      _categoryLabel = picked == null
          ? null
          : cats
                .firstWhere(
                  (c) => c.categoryId == picked,
                  orElse: () => cats.first,
                )
                .name;
    });
  }

  Future<void> _pickBrand() async {
    final brands = ref.read(brandOverviewProvider).valueOrNull ?? const [];
    final picked = await showCategoryBrandPickerSheet(
      context: context,
      title: 'Chọn thương hiệu',
      items: brands.map((b) => PickerItem(id: b.id, name: b.name)).toList(),
      selectedId: _filter.brandId,
    );
    if (!mounted) return;
    setState(() {
      _filter = _filter.copyWith(brandId: picked);
      _brandLabel = picked == null
          ? null
          : brands
                .firstWhere((b) => b.id == picked, orElse: () => brands.first)
                .name;
    });
  }

  Future<void> _createProduct() async {
    final newId = await showCreateEditProductSheet(context);
    if (!mounted) return;
    if (newId != null) {
      unawaited(context.push('/catalog/products/$newId'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final canWrite = ref.watch(canWriteProductsProvider);
    final async = ref.watch(productListProvider(_filter));

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
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
                  categoryLabel: _categoryLabel,
                  brandLabel: _brandLabel,
                  onCategoryTap: _pickCategory,
                  onBrandTap: _pickBrand,
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
                    onProductTap: (item) =>
                        context.push('/catalog/products/${item.id}'),
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
