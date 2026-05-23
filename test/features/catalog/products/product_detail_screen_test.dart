import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_container_lot.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_stock_location.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_umo.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/product_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

ProductDetail _detail({
  String? cat,
  String? brand,
  String? imageUrl,
  List<ProductStockLocation> stocks = const [],
  List<ProductUmo> umos = const [],
  List<ProductVariant> variants = const [],
}) => ProductDetail(
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
  imageUrl: imageUrl,
  stocks: stocks,
  umos: umos,
  variants: variants,
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
        productByIdProvider('p-1').overrideWith(
          (_) => _detail(
            brand: 'TN',
            stocks: const [
              ProductStockLocation(warehouseId: 'w-1', qty: 19),
              ProductStockLocation(
                warehouseId: 'w-1',
                qty: 5,
                variantId: 'v-1',
              ),
            ],
            umos: const [
              ProductUmo(
                id: 'u-1',
                label: 'Thùng',
                ratio: 24,
                sellPrice: 500000,
              ),
            ],
            variants: const [
              ProductVariant(
                id: 'v-1',
                productId: 'p-1',
                name: 'Size L',
                isDefault: false,
                sellPrice: 30000,
                barcode: 'VAR-1',
                avgCost: 0,
                totalCostValue: 0,
                totalQtyImported: 0,
              ),
            ],
          ),
        ),
        productContainerLotsProvider('p-1').overrideWith(
          (_) async => [
            ProductContainerLot(
              id: 'lot-base-1',
              orgId: 'o-1',
              warehouseId: 'w-1',
              productId: 'p-1',
              qtyInitial: 10,
              qtyRemaining: 7,
              barcode: 'LOT-BASE',
              createdAt: DateTime(2026, 5, 20),
            ),
            ProductContainerLot(
              id: 'lot-variant-1',
              orgId: 'o-1',
              warehouseId: 'w-1',
              productId: 'p-1',
              qtyInitial: 6,
              qtyRemaining: 3,
              barcode: 'LOT-VAR',
              variantId: 'v-1',
              variantName: 'Size L',
              createdAt: DateTime(2026, 5, 21),
            ),
          ],
        ),
        canWriteProductsProvider.overrideWithValue(true),
        productWarehouseOptionsProvider.overrideWith(
          (_) async => const [
            ProductWarehouseOption(warehouseId: 'w-1', name: 'Kho 1'),
          ],
        ),
      ]),
    );
    await t.pump();
    await t.pump();
    expect(find.text('Cà phê'), findsWidgets);
    expect(find.text('Phân loại'), findsOneWidget);
    expect(find.text('Giá'), findsOneWidget);
    expect(find.text('Đơn vị quy đổi'), findsOneWidget);
    expect(find.text('Thùng'), findsOneWidget);
    expect(find.text('Biến thể bán hàng'), findsOneWidget);
    expect(find.text('Size L'), findsWidgets);
    expect(find.text('Có mã vạch'), findsNothing);
    expect(find.text('VAR-1'), findsNothing);
    await t.scrollUntilVisible(
      find.byKey(const ValueKey('stock-summary-variants')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Tồn kho đơn vị gốc'), findsOneWidget);
    expect(find.text('26 Cái'), findsWidgets);
    expect(find.text('Tồn kho biến thể'), findsOneWidget);
    expect(find.text('Chạm để xem theo chi nhánh'), findsOneWidget);
    expect(find.text('8 Cái'), findsWidgets);
    await t.scrollUntilVisible(
      find.byKey(const ValueKey('product-container-lots-section')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lô hàng'), findsOneWidget);
    expect(find.text('2 lô đang theo dõi'), findsOneWidget);
    expect(find.text('Tổng còn 10 Cái'), findsOneWidget);
    expect(find.text('Kho 1'), findsWidgets);
    expect(find.text('LOT-BASE'), findsOneWidget);
    expect(find.text('LOT-VAR'), findsOneWidget);
    expect(find.text('Size L'), findsWidgets);
    expect(find.text('Đã dùng 50%'), findsOneWidget);
    expect(find.byKey(const ValueKey('variant-stock-v-1')), findsNothing);
    await t.scrollUntilVisible(
      find.byKey(const ValueKey('stock-summary-variants')),
      -160,
      scrollable: find.byType(Scrollable).first,
    );
    await t.tap(find.byKey(const ValueKey('stock-summary-variants')));
    await t.pumpAndSettle();
    expect(find.text('Tồn kho biến thể'), findsWidgets);
    expect(find.byKey(const ValueKey('variant-stock-v-1')), findsOneWidget);
    expect(find.text('Kho 1'), findsWidgets);
    expect(find.text('Tồn kho'), findsWidgets);
    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('Mô tả'), findsOneWidget);
    expect(find.text('TN'), findsOneWidget); // brand name rendered
    expect(find.text('—'), findsWidgets); // null fields shown as em-dash
  });

  testWidgets('action menu hidden when !canWrite', (t) async {
    await t.pumpWidget(
      _app([
        productByIdProvider('p-1').overrideWith((_) => _detail()),
        productContainerLotsProvider('p-1').overrideWith((_) async => const []),
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
        productContainerLotsProvider('p-1').overrideWith((_) async => const []),
        canWriteProductsProvider.overrideWithValue(true),
      ]),
    );
    await t.pump();
    // Open the action menu
    await t.tap(find.byTooltip('Tác vụ'));
    await t.pumpAndSettle();
    expect(find.text('Buôn bán lại'), findsOneWidget);
  });

  testWidgets('tapping product image opens viewer', (t) async {
    await t.pumpWidget(
      _app([
        productByIdProvider(
          'p-1',
        ).overrideWith((_) => _detail(imageUrl: 'coffee.jpg')),
        productContainerLotsProvider('p-1').overrideWith((_) async => const []),
        canWriteProductsProvider.overrideWithValue(false),
      ]),
    );
    await t.pump();

    await t.tap(find.byKey(const ValueKey('product-detail-image')));
    await t.pumpAndSettle();

    expect(find.byKey(const ValueKey('product-image-viewer')), findsOneWidget);
    expect(find.byTooltip('Đóng ảnh'), findsOneWidget);
  });
}
