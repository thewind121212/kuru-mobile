import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/product_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

ProductDetail _detail({String? cat, String? brand}) => ProductDetail(
  id: 'p-1',
  name: 'Cà phê',
  status: ProductStatus.active,
  baseUnitCode: 'each',
  baseUnitLabel: 'Cái',
  sellPrice: 25000,
  categoryId: cat,
  brandId: 'b-1',
  brandName: brand,
  description: 'mô tả ngắn',
  demandStock: 5,
  avgCost: 18000,
  totalCostValue: 100000,
  totalQtyImported: 24,
);

Widget _app(List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: const ProductDetailScreen(productId: 'p-1'),
  ),
);

void main() {
  testWidgets('renders all sections', (t) async {
    await t.pumpWidget(
      _app([
        productByIdProvider('p-1').overrideWith((_) => _detail(brand: 'TN')),
        canWriteProductsProvider.overrideWithValue(true),
      ]),
    );
    await t.pump();
    expect(find.text('Cà phê'), findsWidgets);
    expect(find.text('Phân loại'), findsOneWidget);
    expect(find.text('Giá'), findsOneWidget);
    expect(find.text('Tồn kho'), findsOneWidget);
    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('Mô tả'), findsOneWidget);
    expect(find.text('TN'), findsOneWidget); // brand name rendered
    expect(find.text('—'), findsWidgets); // null fields shown as em-dash
  });

  testWidgets('action menu hidden when !canWrite', (t) async {
    await t.pumpWidget(
      _app([
        productByIdProvider('p-1').overrideWith((_) => _detail()),
        canWriteProductsProvider.overrideWithValue(false),
      ]),
    );
    await t.pump();
    expect(find.byTooltip('Tác vụ'), findsNothing);
  });

  testWidgets('Buôn bán lại visible when ARCHIVED + canWrite', (t) async {
    final archived = _detail().copyWith(status: ProductStatus.archived);
    await t.pumpWidget(
      _app([
        productByIdProvider('p-1').overrideWith((_) => archived),
        canWriteProductsProvider.overrideWithValue(true),
      ]),
    );
    await t.pump();
    // Open the action menu
    await t.tap(find.byTooltip('Tác vụ'));
    await t.pumpAndSettle();
    expect(find.text('Buôn bán lại'), findsOneWidget);
  });
}
