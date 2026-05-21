import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/product_form_screen.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ProductRepository {}

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
    overrides: [productRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp.router(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      routerConfig: router,
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateProductBody(name: '_', baseUnitCode: '_', sellPrice: 1),
    );
  });

  testWidgets('renders phase-one enterprise sections', (t) async {
    final repo = _MockRepo();
    await t.pumpWidget(_app(repo: repo, key: GlobalKey()));
    await t.pumpAndSettle();

    expect(find.text('Tạo sản phẩm'), findsWidgets);
    expect(find.text('Thông tin chính'), findsOneWidget);
    expect(find.text('Giá bán'), findsWidgets);
    expect(find.text('Đơn vị & tồn kho', skipOffstage: false), findsOneWidget);
    await t.drag(find.byType(ListView), const Offset(0, -700));
    await t.pumpAndSettle();
    expect(find.text('Mô tả'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Tạo sản phẩm'), findsOneWidget);
  });

  testWidgets('create sends phase-one payload and navigates to detail', (
    t,
  ) async {
    final repo = _MockRepo();
    when(
      () => repo.create(any()),
    ).thenAnswer((_) async => ApiResult.success('new-id'));
    final key = GlobalKey();
    await t.pumpWidget(_app(repo: repo, key: key));
    await t.pumpAndSettle();

    await t.enterText(find.byType(TextField).first, 'Trà sữa');
    (key.currentState! as dynamic).debugSetSellPrice(15000);
    (key.currentState! as dynamic).debugSetImportPrice(8000);
    (key.currentState! as dynamic).debugSetExportPrice(12000);
    (key.currentState! as dynamic).debugSetDemandStock('10');
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
    expect(captured.baseUnitCode, 'each');
    expect(find.text('detail:new-id'), findsOneWidget);
    await t.pump(const Duration(seconds: 5));
  });
}
