import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_stock_location.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_umo.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/product_form_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ProductRepository {}

List<Override> _overrides(_MockRepo repo) => [
  productRepositoryProvider.overrideWithValue(repo),
  currentOrgIdProvider.overrideWithValue('org-test'),
  productWarehouseOptionsProvider.overrideWith(
    (ref) async => const [
      ProductWarehouseOption(warehouseId: 'w-1', name: 'Kho chính'),
      ProductWarehouseOption(warehouseId: 'w-2', name: 'Chi nhánh 2'),
    ],
  ),
];

Widget _app({required _MockRepo repo, required GlobalKey key}) {
  final router = GoRouter(
    initialLocation: '/catalog/products/create',
    routes: [
      GoRoute(
        path: '/catalog/products/create',
        builder: (_, __) => ProductFormScreen(key: key),
      ),
      GoRoute(
        path: '/catalog/products/:id',
        builder: (_, state) =>
            Scaffold(body: Text('detail:${state.pathParameters['id']}')),
      ),
    ],
  );

  return ProviderScope(
    overrides: _overrides(repo),
    child: MaterialApp.router(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      routerConfig: router,
    ),
  );
}

Widget _editApp({
  required _MockRepo repo,
  required GlobalKey key,
  required ProductDetail initial,
}) {
  final router = GoRouter(
    initialLocation: '/host/edit',
    routes: [
      GoRoute(
        path: '/host',
        builder: (_, __) => const Scaffold(body: SizedBox()),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, __) => ProductFormScreen(key: key, initial: initial),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: _overrides(repo),
    child: MaterialApp.router(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      routerConfig: router,
    ),
  );
}

ProductDetail _detail() => const ProductDetail(
  id: 'p-1',
  name: 'Trà sữa',
  status: ProductStatus.active,
  baseUnitCode: 'each',
  sellPrice: 15000,
  demandStock: 10,
  avgCost: 0,
  totalCostValue: 0,
  totalQtyImported: 10,
  stocks: [
    ProductStockLocation(warehouseId: 'w-1', qty: 7),
    ProductStockLocation(warehouseId: 'w-2', qty: 3),
  ],
  umos: [ProductUmo(id: 'u-1', label: 'Thùng', ratio: 24, sellPrice: 240000)],
  variants: [
    ProductVariant(
      id: 'v-1',
      productId: 'p-1',
      name: 'Size M',
      isDefault: false,
      sellPrice: 17000,
      avgCost: 0,
      totalCostValue: 0,
      totalQtyImported: 0,
    ),
  ],
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateProductBody(name: '_', baseUnitCode: '_', sellPrice: 1),
    );
    registerFallbackValue(const UpdateProductInfoBody(productId: '_'));
    registerFallbackValue(const <ProductStockAdjustment>[]);
    registerFallbackValue(const <ProductUmoUpsert>[]);
    registerFallbackValue(const <ProductVariantUpsert>[]);
    registerFallbackValue(const <String>[]);
  });

  testWidgets('renders phase-one enterprise sections', (t) async {
    final repo = _MockRepo();
    await t.pumpWidget(_app(repo: repo, key: GlobalKey()));
    await t.pumpAndSettle();

    expect(find.text('Tạo sản phẩm'), findsWidgets);
    expect(find.text('Thông tin chính'), findsOneWidget);
    expect(find.text('Mô tả'), findsWidgets);
    final scrollable = find.byType(Scrollable).first;
    await t.scrollUntilVisible(
      find.text('Giá nhập'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Giá bán'), findsWidgets);
    await t.scrollUntilVisible(
      find.text('Tồn kho'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Đơn vị cơ sở'), findsWidgets);
    expect(find.text('Tồn kho'), findsOneWidget);
    await t.scrollUntilVisible(
      find.text('Kho chính'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Kho chính', skipOffstage: false), findsOneWidget);
    expect(find.text('Chi nhánh 2', skipOffstage: false), findsOneWidget);
    await t.scrollUntilVisible(
      find.text('Đơn vị tính'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Đơn vị tính'), findsOneWidget);
    expect(find.text('Thêm đơn vị quy đổi'), findsOneWidget);
    await t.scrollUntilVisible(
      find.text('Biến thể'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Biến thể'), findsOneWidget);
    expect(find.text('Thêm biến thể'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Tạo sản phẩm'), findsOneWidget);
  });

  testWidgets('create sends phase-one payload and navigates to detail', (
    t,
  ) async {
    final repo = _MockRepo();
    when(
      () => repo.create(any()),
    ).thenAnswer((_) async => ApiResult.success('new-id'));
    when(
      () => repo.updateUmos(
        productId: any(named: 'productId'),
        upserts: any(named: 'upserts'),
      ),
    ).thenAnswer((_) async => ApiResult.success(null));
    final key = GlobalKey();
    await t.pumpWidget(_app(repo: repo, key: key));
    await t.pumpAndSettle();

    await t.enterText(find.byType(TextField).first, 'Trà sữa');
    (key.currentState! as dynamic).debugSetSellPrice(15000);
    (key.currentState! as dynamic).debugSetImportPrice(8000);
    (key.currentState! as dynamic).debugSetExportPrice(12000);
    (key.currentState! as dynamic).debugSetDemandStock('10');
    (key.currentState! as dynamic).debugSetBranchStock('w-1', '7');
    (key.currentState! as dynamic).debugSetBranchStock('w-2', '3');
    (key.currentState! as dynamic).debugAddUmo(
      label: 'Thùng',
      ratio: '24',
      sellPrice: '240000',
      barcode: 'box-1',
    );
    (key.currentState! as dynamic).debugAddVariant(
      name: 'Size L',
      sellPrice: '18000',
      importPrice: '9000',
      exportPrice: '13000',
    );
    await t.pump();

    await t.tap(find.widgetWithText(FilledButton, 'Tạo sản phẩm'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured =
        verify(() => repo.create(captureAny())).captured.single
            as CreateProductBody;
    expect(captured.name, 'Trà sữa');
    expect(captured.sellPrice, 15000);
    expect(captured.importPrice, 8000);
    expect(captured.exportPrice, 12000);
    expect(captured.demandStock, 10);
    expect(captured.initialStocks.map((stock) => stock.toJson()).toList(), [
      {'warehouseId': 'w-1', 'qty': 7},
      {'warehouseId': 'w-2', 'qty': 3},
    ]);
    expect(captured.variants.map((variant) => variant.toJson()).toList(), [
      {
        'name': 'Size L',
        'sellPrice': 18000,
        'importPrice': 9000,
        'exportPrice': 13000,
      },
    ]);
    expect(captured.baseUnitCode, 'each');
    final umoUpserts =
        verify(
              () => repo.updateUmos(
                productId: 'new-id',
                upserts: captureAny(named: 'upserts'),
              ),
            ).captured.single
            as List<ProductUmoUpsert>;
    expect(umoUpserts.single.toJson(), {
      'label': 'Thùng',
      'ratio': 24,
      'sellPrice': 240000,
      'barcode': 'box-1',
    });
    expect(find.text('detail:new-id'), findsOneWidget);
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('create auto-fills UMO price from base price and ratio', (
    t,
  ) async {
    final repo = _MockRepo();
    when(
      () => repo.create(any()),
    ).thenAnswer((_) async => ApiResult.success('new-id'));
    when(
      () => repo.updateUmos(
        productId: any(named: 'productId'),
        upserts: any(named: 'upserts'),
      ),
    ).thenAnswer((_) async => ApiResult.success(null));
    final key = GlobalKey();
    await t.pumpWidget(_app(repo: repo, key: key));
    await t.pumpAndSettle();

    await t.enterText(find.byType(TextField).first, 'Trà sữa');
    (key.currentState! as dynamic).debugSetSellPrice(15000);
    (key.currentState! as dynamic).debugAddUmo(label: 'Thùng', ratio: '24');
    await t.pump();

    await t.tap(find.widgetWithText(FilledButton, 'Tạo sản phẩm'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final umoUpserts =
        verify(
              () => repo.updateUmos(
                productId: 'new-id',
                upserts: captureAny(named: 'upserts'),
              ),
            ).captured.single
            as List<ProductUmoUpsert>;
    expect(umoUpserts.single.toJson(), {
      'label': 'Thùng',
      'ratio': 24,
      'sellPrice': 360000,
    });
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('edit stock-only sends per-branch deltas', (t) async {
    final repo = _MockRepo();
    when(
      () => repo.adjustStock(
        productId: any(named: 'productId'),
        adjustments: any(named: 'adjustments'),
      ),
    ).thenAnswer((_) async => ApiResult.success(null));
    final key = GlobalKey();
    await t.pumpWidget(_editApp(repo: repo, key: key, initial: _detail()));
    await t.pumpAndSettle();

    (key.currentState! as dynamic).debugSetBranchStock('w-1', '9');
    (key.currentState! as dynamic).debugSetBranchStock('w-2', '1');
    await t.pump();

    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    verifyNever(() => repo.updateInfo(any()));
    verifyNever(
      () => repo.saveVariants(
        productId: any(named: 'productId'),
        variants: any(named: 'variants'),
        deleteVariantIds: any(named: 'deleteVariantIds'),
      ),
    );
    final captured =
        verify(
              () => repo.adjustStock(
                productId: 'p-1',
                adjustments: captureAny(named: 'adjustments'),
              ),
            ).captured.single
            as List<ProductStockAdjustment>;
    expect(captured.map((stock) => stock.toJson()).toList(), [
      {'warehouseId': 'w-1', 'quantity': 2},
      {'warehouseId': 'w-2', 'quantity': -2},
    ]);
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('edit variant changes are saved through SaveProductVariants', (
    t,
  ) async {
    final repo = _MockRepo();
    when(
      () => repo.saveVariants(
        productId: any(named: 'productId'),
        variants: any(named: 'variants'),
        deleteVariantIds: any(named: 'deleteVariantIds'),
      ),
    ).thenAnswer((_) async => ApiResult.success(const <ProductVariant>[]));
    final key = GlobalKey();
    await t.pumpWidget(_editApp(repo: repo, key: key, initial: _detail()));
    await t.pumpAndSettle();

    (key.currentState! as dynamic).debugAddVariant(
      name: 'Size L',
      sellPrice: '19000',
    );
    await t.pump();

    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured = verify(
      () => repo.saveVariants(
        productId: 'p-1',
        variants: captureAny(named: 'variants'),
        deleteVariantIds: captureAny(named: 'deleteVariantIds'),
      ),
    ).captured;
    final variants = captured[0] as List<ProductVariantUpsert>;
    final deleteIds = captured[1] as List<String>;
    expect(variants.map((variant) => variant.toJson()).toList(), [
      {'name': 'Size L', 'sellPrice': 19000},
    ]);
    expect(deleteIds, isEmpty);
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('edit shows current variant image', (t) async {
    final repo = _MockRepo();
    final initial = _detail().copyWith(
      variants: const [
        ProductVariant(
          id: 'v-1',
          productId: 'p-1',
          name: 'Size M',
          isDefault: false,
          sellPrice: 17000,
          imageUrl: 'variant-current.jpg',
          avgCost: 0,
          totalCostValue: 0,
          totalQtyImported: 0,
        ),
      ],
    );
    await t.pumpWidget(
      _editApp(repo: repo, key: GlobalKey(), initial: initial),
    );
    await t.pumpAndSettle();

    await t.scrollUntilVisible(
      find.byKey(const ValueKey('variant-image-v-1')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('variant-image-v-1')), findsOneWidget);
  });
}
