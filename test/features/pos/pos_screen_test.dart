import 'dart:async';

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
import 'package:kuru_mobile/features/pos/data/pos_customer_display_repository.dart';
import 'package:kuru_mobile/features/pos/data/pos_payment_qr_repository.dart';
import 'package:kuru_mobile/features/pos/pos_screen.dart';
import 'package:kuru_mobile/features/pos/providers/pos_customer_display_providers.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;
import 'package:shared_preferences/shared_preferences.dart';

List<Override> _posDisplayOverrides({
  List<PosDisplayTerminal> terminals = const [],
  List<PosPairedDisplay> displays = const [],
}) {
  return [
    posDisplayTerminalsProvider(
      'branch-1',
    ).overrideWith((ref) async => terminals),
    posPairedDisplaysProvider('branch-1').overrideWith((ref) async => displays),
  ];
}

void _useTallTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

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
        ..._posDisplayOverrides(),
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
        ..._posDisplayOverrides(),
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
        ..._posDisplayOverrides(),
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
        ..._posDisplayOverrides(),
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
        ..._posDisplayOverrides(),
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

  testWidgets('selects customer display terminal and pushes cart snapshot', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final displayRepo = _FakeDisplayRepository();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        ..._posDisplayOverrides(
          terminals: const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy 1',
              isDefault: true,
            ),
            PosDisplayTerminal(
              id: 'terminal-2',
              name: 'Quầy 2',
              isDefault: false,
            ),
          ],
          displays: [
            PosPairedDisplay(
              id: 'display-1',
              name: 'Màn hình cửa trước',
              terminalId: 'terminal-1',
              terminalName: 'Quầy 1',
              status: 'PAIRED',
              lastSeenAt: DateTime.now(),
            ),
          ],
        ),
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
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Chọn màn hình'), findsOneWidget);

    await tester.tap(find.text('Chọn màn hình'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Màn hình cửa trước'));
    await tester.pump();
    await tester.tap(find.text('Màn hình cửa trước'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(1));
    final push = displayRepo.pushes.single;
    expect(push.terminalId, 'terminal-1');
    expect(push.items.single.name, 'Cà phê sữa');
    expect(push.items.single.lineTotal, 30000);
    expect(push.subtotal, 30000);
    expect(push.total, 30000);

    await tester.tap(find.text('Màn hình cửa trước'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Quầy 2'));
    await tester.pump();
    await tester.tap(find.text('Quầy 2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(3));
    final switchRelease = displayRepo.pushes[1];
    expect(switchRelease.terminalId, 'terminal-1');
    expect(switchRelease.items, isEmpty);
    expect(switchRelease.sessionId, push.sessionId);
    final secondTerminalPush = displayRepo.pushes[2];
    expect(secondTerminalPush.terminalId, 'terminal-2');
    expect(secondTerminalPush.items.single.name, 'Cà phê sữa');
    expect(secondTerminalPush.sessionId, push.sessionId);

    await tester.tap(find.text('Xóa giỏ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(4));
    final release = displayRepo.pushes.last;
    expect(release.terminalId, 'terminal-2');
    expect(release.items, isEmpty);
    expect(release.subtotal, 0);
    expect(release.total, 0);
    expect(release.sessionId, push.sessionId);
  });

  testWidgets('releases customer display lock after paid sale', (tester) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final displayRepo = _FakeDisplayRepository();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        orderRepositoryProvider.overrideWithValue(
          _FakeOrderRepository(
            expectedTerminalId: 'terminal-1',
            expectedPaymentAmount: 30000,
          ),
        ),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        ..._posDisplayOverrides(
          terminals: const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy 1',
              isDefault: true,
            ),
            PosDisplayTerminal(
              id: 'terminal-2',
              name: 'Quầy 2',
              isDefault: false,
            ),
          ],
        ),
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
        GoRoute(path: '/orders/:id', builder: (_, __) => const SizedBox()),
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
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Chọn màn hình'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Quầy 1'));
    await tester.pump();
    await tester.tap(find.text('Quầy 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(1));
    final cartPush = displayRepo.pushes.single;
    expect(cartPush.terminalId, 'terminal-1');
    expect(cartPush.items.single.name, 'Cà phê sữa');

    await tester.tap(find.text('Thu tiền'));
    await tester.pump();
    expect(find.text('Thanh toán'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pump();
    await tester.tap(find.text('Xác nhận thanh toán'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Thanh toán thành công'), findsOneWidget);
    expect(displayRepo.pushes, hasLength(2));
    final release = displayRepo.pushes.last;
    expect(release.terminalId, 'terminal-1');
    expect(release.items, isEmpty);
    expect(release.total, 0);
    expect(release.sessionId, cartPush.sessionId);
  });

  testWidgets('take over customer display pushes current cart for this POS', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final displayRepo = _FakeDisplayRepository(acceptedSequence: [false, true]);
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        ..._posDisplayOverrides(
          terminals: const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy 1',
              isDefault: true,
            ),
            PosDisplayTerminal(
              id: 'terminal-2',
              name: 'Quầy 2',
              isDefault: false,
            ),
          ],
        ),
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
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Chọn màn hình'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Quầy 1'));
    await tester.pump();
    await tester.tap(find.text('Quầy 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(1));
    final rejected = displayRepo.pushes.single;
    expect(rejected.takeOver, isFalse);
    expect(find.text('Đang được POS khác dùng'), findsOneWidget);
    expect(find.text('Tiếp quản'), findsOneWidget);

    await tester.tap(find.text('Tiếp quản'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(displayRepo.pushes, hasLength(2));
    final takeover = displayRepo.pushes.last;
    expect(takeover.terminalId, 'terminal-1');
    expect(takeover.takeOver, isTrue);
    expect(takeover.sessionId, rejected.sessionId);
    expect(takeover.items.single.name, 'Cà phê sữa');
  });

  testWidgets(
    'take over customer display is available before adding products',
    (tester) async {
      _useTallTestViewport(tester);
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final displayRepo = _FakeDisplayRepository(
        acceptedSequence: [false, true],
      );
      final container = ProviderContainer(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          currentOrgIdProvider.overrideWithValue('org_test'),
          posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
          productWarehouseOptionsProvider.overrideWith((ref) async {
            return const [
              ProductWarehouseOption(
                warehouseId: 'branch-1',
                name: 'Cửa hàng chính',
              ),
            ];
          }),
          ..._posDisplayOverrides(
            terminals: const [
              PosDisplayTerminal(
                id: 'terminal-1',
                name: 'Quầy 1',
                isDefault: true,
              ),
              PosDisplayTerminal(
                id: 'terminal-2',
                name: 'Quầy 2',
                isDefault: false,
              ),
            ],
            displays: [
              PosPairedDisplay(
                id: 'display-1',
                name: 'Màn hình cửa trước',
                terminalId: 'terminal-1',
                terminalName: 'Quầy 1',
                status: 'PAIRED',
                lastSeenAt: DateTime.now(),
              ),
            ],
          ),
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
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Chọn màn hình'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.ensureVisible(find.text('Màn hình cửa trước'));
      await tester.pump();
      await tester.tap(find.text('Màn hình cửa trước'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(displayRepo.pushes, hasLength(1));
      final rejected = displayRepo.pushes.single;
      expect(rejected.items, isEmpty);
      expect(rejected.takeOver, isFalse);
      expect(find.text('Đang được POS khác dùng'), findsOneWidget);
      expect(find.text('Tiếp quản'), findsOneWidget);

      await tester.tap(find.text('Tiếp quản'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(displayRepo.pushes, hasLength(2));
      final takeover = displayRepo.pushes.last;
      expect(takeover.items, isEmpty);
      expect(takeover.takeOver, isTrue);
      expect(takeover.sessionId, rejected.sessionId);
      expect(find.text('Màn hình cửa trước'), findsOneWidget);
      expect(find.text('Đang kết nối'), findsNothing);
    },
  );

  testWidgets('shows display loading while presence data is fetching', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'kuru.pos.terminal.v1.org_test.branch-1': 'terminal-1',
    });
    final prefs = await SharedPreferences.getInstance();
    final displays = Completer<List<PosPairedDisplay>>();
    final displayRepo = _FakeDisplayRepository();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        posDisplayTerminalsProvider('branch-1').overrideWith((ref) async {
          return const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy 1',
              isDefault: true,
            ),
          ];
        }),
        posPairedDisplaysProvider(
          'branch-1',
        ).overrideWith((ref) => displays.future),
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
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Đang tải màn hình'), findsNothing);
    expect(find.text('Mất kết nối'), findsNothing);
    expect(find.text('Chưa ghép màn hình'), findsNothing);

    displays.complete([
      PosPairedDisplay(
        id: 'display-1',
        name: 'Màn hình cửa trước',
        terminalId: 'terminal-1',
        terminalName: 'Quầy 1',
        status: 'PAIRED',
        lastSeenAt: DateTime.now(),
      ),
    ]);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(1));
    expect(find.text('Màn hình cửa trước'), findsOneWidget);
    expect(find.text('Đang tải màn hình'), findsNothing);
    expect(find.text('Đang kết nối'), findsNothing);
  });

  testWidgets('checks selected customer display when POS route renders', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'kuru.pos.terminal.v1.org_test.branch-1': 'terminal-1',
    });
    final prefs = await SharedPreferences.getInstance();
    final displayRepo = _FakeDisplayRepository(acceptedSequence: [false]);
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        ..._posDisplayOverrides(
          terminals: const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy 1',
              isDefault: true,
            ),
            PosDisplayTerminal(
              id: 'terminal-2',
              name: 'Quầy 2',
              isDefault: false,
            ),
          ],
          displays: [
            PosPairedDisplay(
              id: 'display-1',
              name: 'Màn hình cửa trước',
              terminalId: 'terminal-1',
              terminalName: 'Quầy 1',
              status: 'PAIRED',
              lastSeenAt: DateTime.now(),
            ),
          ],
        ),
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
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 400));

    expect(displayRepo.pushes, hasLength(1));
    final rejected = displayRepo.pushes.single;
    expect(rejected.items, isEmpty);
    expect(rejected.takeOver, isFalse);
    expect(find.text('Đang được POS khác dùng'), findsOneWidget);
    expect(find.text('Tiếp quản'), findsOneWidget);
  });

  testWidgets('generates customer display pair code from POS terminal picker', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final displayRepo = _FakeDisplayRepository(
      pairSession: PosPairSession(
        code: '123456',
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      ),
    );
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        currentOrgIdProvider.overrideWithValue('org_test'),
        posCustomerDisplayRepositoryProvider.overrideWithValue(displayRepo),
        productWarehouseOptionsProvider.overrideWith((ref) async {
          return const [
            ProductWarehouseOption(
              warehouseId: 'branch-1',
              name: 'Cửa hàng chính',
            ),
          ];
        }),
        ..._posDisplayOverrides(
          terminals: const [
            PosDisplayTerminal(
              id: 'terminal-1',
              name: 'Quầy chính',
              isDefault: true,
            ),
          ],
          displays: [
            PosPairedDisplay(
              id: 'display-1',
              name: 'Màn hình cửa trước',
              terminalId: 'terminal-1',
              terminalName: 'Quầy chính',
              status: 'PAIRED',
              lastSeenAt: DateTime.now(),
            ),
          ],
        ),
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
    await tester.pump(const Duration(milliseconds: 50));

    final chip = find.text('Màn hình cửa trước').evaluate().isNotEmpty
        ? find.text('Màn hình cửa trước')
        : find.text('Chọn màn hình');
    await tester.tap(chip);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Ghép lại'));
    await tester.pump();
    await tester.tap(find.text('Ghép lại'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ghép lại màn hình khách'), findsOneWidget);
    expect(find.text('Màn hình cửa trước'), findsAtLeastNWidgets(1));
    expect(find.text('Tên màn hình'), findsNothing);
    await tester.tap(find.text('Tạo mã ghép'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(displayRepo.createdName, 'Màn hình cửa trước');
    expect(find.text('123 456'), findsOneWidget);
  });
}

class _FakeOrderRepository extends OrderRepository {
  _FakeOrderRepository({
    this.expectedTerminalId,
    this.expectedPaymentAmount = 50000,
  }) : super(Dio(), uuidFactory: () => 'idem-pos-1');

  final String? expectedTerminalId;
  final double expectedPaymentAmount;

  @override
  Future<ApiResult<String>> createOrder({
    required String orgId,
    required String idempotencyKey,
    required OrderCartDraft draft,
    String? storeId,
    String? terminalId,
    OrderPaymentInput? payment,
  }) async {
    expect(orgId, 'org_test');
    expect(idempotencyKey, 'idem-pos-1');
    expect(storeId, 'branch-1');
    expect(terminalId, expectedTerminalId);
    expect(draft.items.single.productName, 'Cà phê sữa');
    expect(payment?.amount, expectedPaymentAmount);
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

class _FakeDisplayRepository extends PosCustomerDisplayRepository {
  _FakeDisplayRepository({this.pairSession, List<bool>? acceptedSequence})
    : acceptedSequence = acceptedSequence ?? [],
      super(Dio());

  final PosPairSession? pairSession;
  final List<bool> acceptedSequence;
  final List<_PushCall> pushes = [];
  String? createdName;

  @override
  Future<ApiResult<List<PosDisplayTerminal>>> listTerminals({
    required String storeId,
  }) async {
    return ApiResult.success(const []);
  }

  @override
  Future<ApiResult<List<PosPairedDisplay>>> listPairedDisplays({
    String? storeId,
    String? terminalId,
  }) async {
    return ApiResult.success(const []);
  }

  @override
  Future<ApiResult<PosPairSession>> createPairSession({
    required String terminalId,
    String? name,
    String? description,
    String? rebindDeviceId,
  }) async {
    createdName = name;
    return ApiResult.success(
      pairSession ??
          PosPairSession(
            code: '654321',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
    );
  }

  @override
  Future<ApiResult<bool>> cancelPairSession({
    required String terminalId,
  }) async {
    return ApiResult.success(true);
  }

  @override
  Future<ApiResult<PosDisplayPushResult>> pushCart({
    required String terminalId,
    required List<PosDisplayCartItem> items,
    required double subtotal,
    required double discount,
    required double total,
    required String sessionId,
    bool takeOver = false,
    String? customerName,
  }) async {
    final accepted = acceptedSequence.isEmpty || acceptedSequence.removeAt(0);
    pushes.add(
      _PushCall(
        terminalId: terminalId,
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        sessionId: sessionId,
        takeOver: takeOver,
      ),
    );
    return ApiResult.success(
      PosDisplayPushResult(ok: true, accepted: accepted),
    );
  }
}

class _PushCall {
  const _PushCall({
    required this.terminalId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.sessionId,
    required this.takeOver,
  });

  final String terminalId;
  final List<PosDisplayCartItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final String sessionId;
  final bool takeOver;
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
