import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/catalog_launcher_screen.dart';

GoRouter _routerHarness() {
  return GoRouter(
    initialLocation: '/catalog',
    routes: [
      GoRoute(
        path: '/catalog',
        builder: (_, __) => const CatalogLauncherScreen(),
        routes: [
          GoRoute(
            path: 'categories',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('CATEGORIES_HIT'))),
          ),
          GoRoute(
            path: 'brands',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('BRANDS_HIT'))),
          ),
          GoRoute(
            path: 'products',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('PRODUCTS_HIT'))),
          ),
        ],
      ),
    ],
  );
}

Widget _harness() {
  final router = _routerHarness();
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets('renders catalog cards with products inside catalog', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.text('Catalogue'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Tax'), findsNothing);
    expect(find.text('Coming soon'), findsNothing);
  });

  testWidgets('tap Products card → navigates to /catalog/products', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Products'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('PRODUCTS_HIT'), findsOneWidget);
  });

  testWidgets('tap Categories card → navigates to /catalog/categories', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Categories'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('CATEGORIES_HIT'), findsOneWidget);
  });

  testWidgets('tap Brands card → navigates to /catalog/brands', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Brands'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('BRANDS_HIT'), findsOneWidget);
  });

  testWidgets('setup launcher stays on card surface after idle tap area', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
  });
}
