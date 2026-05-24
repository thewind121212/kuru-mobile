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
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
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
