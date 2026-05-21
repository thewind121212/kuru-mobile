// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (pos.pixels >= pos.maxScrollExtent - 200) {
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
          child: ListView(
            controller: _scrollCtrl,
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 4),
                child: Text(
                  'Sản phẩm',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                child: Text(
                  async.maybeWhen(
                    data: (p) => '${p.totalProducts} sản phẩm',
                    orElse: () => 'Đang tải…',
                  ),
                  style: TextStyle(fontSize: 13, color: c.textMuted),
                ),
              ),
              ProductFilterBar(
                searchController: _searchCtrl,
                categoryLabel: _categoryLabel,
                brandLabel: _brandLabel,
                onCategoryTap: _pickCategory,
                onBrandTap: _pickBrand,
              ),
              async.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text('Không tải được danh sách: $e')),
                ),
                data: (page) {
                  if (page.items.isEmpty) {
                    return Padding(
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
                            style: TextStyle(fontSize: 13, color: c.textMuted),
                          ),
                          if (canWrite) ...[
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () async {
                                final newId = await showCreateEditProductSheet(
                                  context,
                                );
                                if (!context.mounted) return;
                                if (newId != null) {
                                  unawaited(
                                    context.push('/catalog/products/$newId'),
                                  );
                                }
                              },
                              child: const Text('Tạo sản phẩm'),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return _ProductMasonryGrid(
                    items: page.items,
                    hasMore: page.hasMore,
                    onProductTap: (item) =>
                        context.push('/catalog/products/${item.id}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              onPressed: () async {
                final newId = await showCreateEditProductSheet(context);
                if (!context.mounted) return;
                if (newId != null) {
                  unawaited(context.push('/catalog/products/$newId'));
                }
              },
              icon: const Icon(TablerIcons.plus),
              label: const Text('Tạo sản phẩm'),
            )
          : null,
    );
  }
}

class _ProductMasonryGrid extends StatelessWidget {
  const _ProductMasonryGrid({
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columnCount = switch (constraints.maxWidth) {
        < 340 => 1,
        >= 700 => 3,
        _ => 2,
      };
      final columnWidth =
          (constraints.maxWidth -
              (_horizontalPadding * 2) -
              (_gap * (columnCount - 1))) /
          columnCount;
      final columns = _columnsFor(columnCount, columnWidth);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < columns.length; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final tile in columns[i]) ...[
                          ProductCard(
                            product: tile.product,
                            imageAspectRatio: tile.imageAspectRatio,
                            onTap: () => onProductTap(tile.product),
                          ),
                          const SizedBox(height: _gap),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (hasMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    },
  );

  List<List<_MasonryTile>> _columnsFor(int columnCount, double columnWidth) {
    final columns = List.generate(columnCount, (_) => <_MasonryTile>[]);
    final heights = List<double>.filled(columnCount, 0);

    for (var i = 0; i < items.length; i++) {
      final product = items[i];
      final ratio = _imageAspectRatio(product, i);
      final target = _shortestColumnIndex(heights);
      columns[target].add(
        _MasonryTile(product: product, imageAspectRatio: ratio),
      );
      heights[target] += (columnWidth / ratio) + _estimatedInfoHeight(product);
    }

    return columns;
  }

  static int _shortestColumnIndex(List<double> heights) {
    var index = 0;
    for (var i = 1; i < heights.length; i++) {
      if (heights[i] < heights[index]) index = i;
    }
    return index;
  }

  static double _imageAspectRatio(ProductSummary product, int index) {
    if (!product.hasImage) return 0.95;
    const ratios = [0.78, 0.9, 1.05, 0.84, 0.98];
    final seed = product.id.codeUnits.fold<int>(
      index,
      (value, unit) => value + unit,
    );
    return ratios[seed % ratios.length];
  }

  static double _estimatedInfoHeight(ProductSummary product) {
    final nameRows = product.name.length > 22 ? 2 : 1;
    return 70 + (nameRows * 15) + _gap;
  }
}

class _MasonryTile {
  const _MasonryTile({required this.product, required this.imageAspectRatio});

  final ProductSummary product;
  final double imageAspectRatio;
}
