import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/products_list_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

ProductSummary _ps(String id) => ProductSummary(
  id: id,
  name: 'Tên $id',
  status: ProductStatus.active,
  baseUnitCode: 'each',
  sellPricePerUnit: 1000,
  currentStock: 5,
  demandStock: 2,
  variantCount: 0,
);

Widget _app(List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: const ProductsListScreen(),
  ),
);

void main() {
  testWidgets('renders title + items', (t) async {
    await t.pumpWidget(
      _app([
        productListProvider.overrideWith(
          () => _StubNotifier(
            ProductListPage(
              items: [_ps('1'), _ps('2')],
              page: 1,
              limit: 50,
              totalProducts: 2,
            ),
          ),
        ),
        canWriteProductsProvider.overrideWithValue(false),
        categoryOverviewProvider.overrideWith((ref) async => const []),
        brandOverviewProvider.overrideWith((ref) async => const []),
        variantAttributeOverviewProvider.overrideWith((ref) async => const []),
        productWarehouseOptionsProvider.overrideWith((ref) async => const []),
      ]),
    );
    await t.pump();
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Tên 1'), findsOneWidget);
    expect(find.text('Tên 2'), findsOneWidget);
  });

  testWidgets('empty state shows CTA when canWrite', (t) async {
    await t.pumpWidget(
      _app([
        productListProvider.overrideWith(
          () => _StubNotifier(
            const ProductListPage(
              items: [],
              page: 1,
              limit: 50,
              totalProducts: 0,
            ),
          ),
        ),
        canWriteProductsProvider.overrideWithValue(true),
        categoryOverviewProvider.overrideWith((ref) async => const []),
        brandOverviewProvider.overrideWith((ref) async => const []),
        variantAttributeOverviewProvider.overrideWith((ref) async => const []),
        productWarehouseOptionsProvider.overrideWith((ref) async => const []),
      ]),
    );
    await t.pump();
    expect(find.text('Chưa có sản phẩm'), findsOneWidget);
    expect(find.text('Tạo sản phẩm'), findsWidgets);
  });

  testWidgets('FAB hidden when !canWrite', (t) async {
    await t.pumpWidget(
      _app([
        productListProvider.overrideWith(
          () => _StubNotifier(
            ProductListPage(
              items: [_ps('1')],
              page: 1,
              limit: 50,
              totalProducts: 1,
            ),
          ),
        ),
        canWriteProductsProvider.overrideWithValue(false),
        categoryOverviewProvider.overrideWith((ref) async => const []),
        brandOverviewProvider.overrideWith((ref) async => const []),
        variantAttributeOverviewProvider.overrideWith((ref) async => const []),
        productWarehouseOptionsProvider.overrideWith((ref) async => const []),
      ]),
    );
    await t.pump();
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}

class _StubNotifier extends ProductListNotifier {
  _StubNotifier(this._initial);
  final ProductListPage _initial;
  @override
  Future<ProductListPage> build(ProductListFilter arg) async => _initial;
}
