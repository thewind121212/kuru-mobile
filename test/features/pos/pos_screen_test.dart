import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/pos/data/pos_payment_qr_repository.dart';
import 'package:kuru_mobile/features/pos/pos_screen.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders POS cart and submits a paid sale', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        orderRepositoryProvider.overrideWithValue(_FakeOrderRepository()),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(orderCartProvider.notifier)
        .addLine(
          const OrderLineItem(
            productId: 'p1',
            productName: 'Cà phê sữa',
            baseUnitCode: 'ly',
            qty: 2,
            unitPrice: 15000,
          ),
        );

    final router = GoRouter(
      initialLocation: '/pos',
      routes: [
        GoRoute(path: '/pos', builder: (_, __) => const PosScreen()),
        GoRoute(
          path: '/orders/:id',
          builder: (_, state) =>
              Scaffold(body: Text('ORDER_${state.pathParameters['id']}')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Thu ngân'), findsOneWidget);
    expect(find.text('Cửa hàng chính'), findsOneWidget);
    expect(find.text('Nhập tên sản phẩm'), findsOneWidget);
    expect(find.byTooltip('Quét sản phẩm'), findsWidgets);
    expect(find.text('Giỏ hàng (1)'), findsOneWidget);
    expect(find.text('Cà phê sữa'), findsOneWidget);

    await tester.tap(find.text('Thu tiền'));
    await tester.pump();

    expect(find.text('Thanh toán'), findsOneWidget);
    expect(find.text('Tiền khách đưa'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '50000');
    await tester.pump();
    expect(find.text('Tiền thối'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pump();
    await tester.tap(find.text('Xác nhận thanh toán'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Thanh toán thành công'), findsOneWidget);

    await tester.tap(find.text('Xem đơn vừa tạo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('ORDER_order_pos_1'), findsOneWidget);
  });

  testWidgets('opens POS cart line adjustment in a bottom sheet', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(orderCartProvider.notifier)
        .addLine(
          const OrderLineItem(
            productId: 'p1',
            productName: 'Áo thun',
            variantId: 'v1',
            variantName: 'Size M / Đỏ',
            baseUnitCode: 'cái',
            qty: 1,
            unitPrice: 99000,
          ),
        );

    final router = GoRouter(
      initialLocation: '/pos',
      routes: [GoRoute(path: '/pos', builder: (_, __) => const PosScreen())],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Size M / Đỏ'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Chỉnh dòng hàng'), findsOneWidget);
    expect(find.text('Cập nhật'), findsOneWidget);
    expect(find.byTooltip('Xem chi tiết sản phẩm'), findsOneWidget);
    expect(find.text('Giá gốc'), findsOneWidget);
    expect(find.text('Giảm giá'), findsOneWidget);
    expect(find.text('Số tiền giảm'), findsOneWidget);
    expect(find.text('Bấm để giảm'), findsOneWidget);
    expect(find.text('+5%'), findsNothing);
    expect(find.text('+10%'), findsNothing);
    expect(find.text('+1%'), findsNothing);
  });

  testWidgets('search add opens variant picker for variant products', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/pos',
      routes: [GoRoute(path: '/pos', builder: (_, __) => const PosScreen())],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'ao');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Áo thun biến thể'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Chọn phân loại'), findsOneWidget);
    expect(find.text('Size M / Đỏ'), findsOneWidget);
    expect(container.read(orderCartProvider).items, isEmpty);

    await tester.ensureVisible(find.text('Size M / Đỏ'));
    await tester.pump();
    await tester.tap(find.text('Size M / Đỏ'));
    await tester.pump(const Duration(seconds: 1));

    final item = container.read(orderCartProvider).items.single;
    expect(item.productId, 'p_variant');
    expect(item.variantId, 'v_red_m');
    expect(item.variantName, 'Size M / Đỏ');
    expect(item.unitPrice, 99000);
  });

  testWidgets('search add auto-selects single-variant products', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final repo = _FakeSingleVariantProductRepository();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        productRepositoryProvider.overrideWithValue(repo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/pos',
      routes: [GoRoute(path: '/pos', builder: (_, __) => const PosScreen())],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'caphe');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Cà phê thường'));
    await tester.pump();

    expect(find.text('Chọn phân loại'), findsNothing);
    expect(repo.getByIdCalled, true);
    final item = container.read(orderCartProvider).items.single;
    expect(item.productId, 'p_single');
    expect(item.variantId, 'v_single');
    expect(item.variantName, 'Ly vừa');
    expect(item.unitPrice, 27000);
  });

  testWidgets('bank transfer payment renders generated VietQR details', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posPaymentQrRepositoryProvider.overrideWithValue(_FakeQrRepository()),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(orderCartProvider.notifier)
        .addLine(
          const OrderLineItem(
            productId: 'p1',
            productName: 'Cà phê sữa',
            baseUnitCode: 'ly',
            qty: 1,
            unitPrice: 25000,
          ),
        );

    final router = GoRouter(
      initialLocation: '/pos',
      routes: [GoRoute(path: '/pos', builder: (_, __) => const PosScreen())],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Thu tiền'));
    await tester.pump();
    await tester.tap(find.text('Chuyển khoản'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byKey(const ValueKey('pos-vietqr-image')), findsOneWidget);
    expect(find.text('VCB'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    expect(find.text('KURUODH250524ABC123'), findsOneWidget);
  });
}

class _FakeOrderRepository extends OrderRepository {
  _FakeOrderRepository() : super(Dio(), uuidFactory: () => 'idem-pos-1');

  @override
  Future<ApiResult<String>> createOrder({
    required String orgId,
    required String idempotencyKey,
    required OrderCartDraft draft,
    String? storeId,
    OrderPaymentInput? payment,
  }) async {
    expect(orgId, 'org_test');
    expect(idempotencyKey, 'idem-pos-1');
    expect(storeId, 'branch-1');
    expect(draft.items.single.productName, 'Cà phê sữa');
    expect(payment?.amount, 50000);
    return ApiResult.success('order_pos_1');
  }
}

class _FakeQrRepository extends PosPaymentQrRepository {
  _FakeQrRepository() : super(Dio());

  @override
  Future<ApiResult<PosPaymentQr>> generate({
    required String orgId,
    required String refNumber,
    required double amount,
  }) async {
    expect(orgId, 'org_test');
    expect(amount, 25000);
    return ApiResult.success(
      const PosPaymentQr(
        qrUrl: 'https://example.com/vietqr.png',
        memo: 'KURUODH250524ABC123',
        bankCode: 'VCB',
        accountNumber: '123456789',
        accountName: 'Kuru Test',
      ),
    );
  }
}

class _FakeProductRepository extends ProductRepository {
  _FakeProductRepository() : super(Dio());

  @override
  Future<ApiResult<ProductListPage>> getOverview({
    required ProductListFilter filter,
    int page = 1,
    int limit = 50,
  }) async {
    return ApiResult.success(
      const ProductListPage(
        items: [
          ProductSummary(
            id: 'p_variant',
            name: 'Áo thun biến thể',
            status: ProductStatus.active,
            baseUnitCode: 'cái',
            sellPricePerUnit: 89000,
            currentStock: 4,
            demandStock: 0,
            variantCount: 2,
          ),
        ],
        page: 1,
        limit: 50,
        totalProducts: 1,
        maxSellPrice: 99000,
      ),
    );
  }

  @override
  Future<ApiResult<ProductDetail>> getById(String productId) async {
    expect(productId, 'p_variant');
    return ApiResult.success(
      const ProductDetail(
        id: 'p_variant',
        name: 'Áo thun biến thể',
        status: ProductStatus.active,
        baseUnitCode: 'cái',
        sellPrice: 89000,
        demandStock: 0,
        avgCost: 0,
        totalCostValue: 0,
        totalQtyImported: 0,
        variants: [
          ProductVariant(
            id: 'v_default',
            productId: 'p_variant',
            name: 'Mặc định',
            isDefault: true,
            avgCost: 0,
            totalCostValue: 0,
            totalQtyImported: 0,
          ),
          ProductVariant(
            id: 'v_red_m',
            productId: 'p_variant',
            name: 'Size M / Đỏ',
            isDefault: false,
            sellPrice: 99000,
            attributes: {'size': 'M', 'color': 'Đỏ'},
            avgCost: 0,
            totalCostValue: 0,
            totalQtyImported: 0,
          ),
          ProductVariant(
            id: 'v_blue_l',
            productId: 'p_variant',
            name: 'Size L / Xanh',
            isDefault: false,
            sellPrice: 109000,
            attributes: {'size': 'L', 'color': 'Xanh'},
            avgCost: 0,
            totalCostValue: 0,
            totalQtyImported: 0,
          ),
        ],
      ),
    );
  }
}

class _FakeSingleVariantProductRepository extends ProductRepository {
  _FakeSingleVariantProductRepository() : super(Dio());

  bool getByIdCalled = false;

  @override
  Future<ApiResult<ProductListPage>> getOverview({
    required ProductListFilter filter,
    int page = 1,
    int limit = 50,
  }) async {
    return ApiResult.success(
      const ProductListPage(
        items: [
          ProductSummary(
            id: 'p_single',
            name: 'Cà phê thường',
            status: ProductStatus.active,
            baseUnitCode: 'ly',
            sellPricePerUnit: 25000,
            currentStock: 8,
            demandStock: 0,
            variantCount: 1,
          ),
        ],
        page: 1,
        limit: 50,
        totalProducts: 1,
      ),
    );
  }

  @override
  Future<ApiResult<ProductDetail>> getById(String productId) async {
    getByIdCalled = true;
    return ApiResult.success(
      const ProductDetail(
        id: 'p_single',
        name: 'Cà phê thường',
        status: ProductStatus.active,
        baseUnitCode: 'ly',
        sellPrice: 25000,
        demandStock: 0,
        avgCost: 0,
        totalCostValue: 0,
        totalQtyImported: 0,
        variants: [
          ProductVariant(
            id: 'v_single',
            productId: 'p_single',
            name: 'Ly vừa',
            isDefault: false,
            sellPrice: 27000,
            avgCost: 0,
            totalCostValue: 0,
            totalQtyImported: 0,
          ),
        ],
      ),
    );
  }
}
