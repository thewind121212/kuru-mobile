import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_barcode.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_stock_location.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/product_variant_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

ProductDetail _detail() => const ProductDetail(
  id: 'p-1',
  name: 'Cà phê',
  status: ProductStatus.active,
  baseUnitCode: 'each',
  baseUnitLabel: 'Cái',
  sellPrice: 25000,
  importPrice: 15000,
  exportPrice: 28000,
  demandStock: 5,
  avgCost: 17000,
  totalCostValue: 100000,
  totalQtyImported: 24,
  variants: [
    ProductVariant(
      id: 'v-1',
      productId: 'p-1',
      name: 'Size L',
      isDefault: false,
      sellPrice: 30000,
      importPrice: 18000,
      attributes: {'Size': 'L'},
      avgCost: 19000,
      totalCostValue: 38000,
      totalQtyImported: 2,
    ),
  ],
  stocks: [
    ProductStockLocation(warehouseId: 'w-1', qty: 5, variantId: 'v-1'),
    ProductStockLocation(warehouseId: 'w-2', qty: 2, variantId: 'v-1'),
  ],
  barcodes: [
    ProductBarcode(
      id: 'bc-alias',
      value: 'ALIAS-1',
      kind: 'ALIAS',
      productId: 'p-1',
      variantId: 'v-1',
    ),
    ProductBarcode(
      id: 'bc-internal',
      value: 'INTERNAL-1',
      kind: 'INTERNAL',
      productId: 'p-1',
      variantId: 'v-1',
    ),
  ],
);

Widget _app(ProductDetail detail) => ProviderScope(
  overrides: [
    productWarehouseOptionsProvider.overrideWith(
      (ref) async => const [
        ProductWarehouseOption(warehouseId: 'w-1', name: 'Kho 1'),
        ProductWarehouseOption(warehouseId: 'w-2', name: 'Kho 2'),
      ],
    ),
  ],
  child: MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: ProductVariantDetailScreen(
      productId: detail.id,
      variantId: 'v-1',
      initial: detail,
    ),
  ),
);

void main() {
  testWidgets('renders variant price, branch stock, and alias barcode only', (
    t,
  ) async {
    await t.pumpWidget(_app(_detail()));
    await t.pump();

    expect(find.text('Size L'), findsWidgets);
    expect(find.text('Cà phê'), findsOneWidget);
    expect(find.textContaining('30.000'), findsWidgets);
    expect(find.textContaining('18.000'), findsOneWidget);
    expect(find.textContaining('28.000'), findsOneWidget);
    expect(find.text('Size: L'), findsOneWidget);
    expect(find.text('7 Cái'), findsWidgets);
    expect(find.text('Kho 1'), findsOneWidget);
    expect(find.text('5 Cái'), findsOneWidget);
    expect(find.text('Kho 2'), findsOneWidget);
    expect(find.text('2 Cái'), findsOneWidget);
    expect(find.text('ALIAS-1'), findsOneWidget);
    expect(find.text('INTERNAL-1'), findsNothing);
  });

  testWidgets('uses variant image when present', (t) async {
    final detail = _detail().copyWith(
      variants: const [
        ProductVariant(
          id: 'v-1',
          productId: 'p-1',
          name: 'Size L',
          isDefault: false,
          sellPrice: 30000,
          imageUrl: 'variant.jpg',
          avgCost: 19000,
          totalCostValue: 38000,
          totalQtyImported: 2,
        ),
      ],
    );
    await t.pumpWidget(_app(detail));
    await t.pump();

    expect(find.byKey(const ValueKey('variant-detail-image')), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('variant-detail-image-tap-target')));
    await t.pumpAndSettle();

    expect(find.byKey(const ValueKey('variant-image-viewer')), findsOneWidget);
    expect(find.byTooltip('Đóng ảnh'), findsOneWidget);
  });
}
