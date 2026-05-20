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
  testWidgets('renders 4 cards (3 live + 1 disabled)', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
    // Products tile (hardcoded VI string per spec §11).
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Tax'), findsOneWidget);
    // Only Tax remains as the disabled "Coming soon" tile.
    expect(find.text('Coming soon'), findsOneWidget);
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

  testWidgets('tap Products card → navigates to /catalog/products', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Sản phẩm'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('PRODUCTS_HIT'), findsOneWidget);
  });

  testWidgets('tap disabled Tax card → no navigation', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Tax'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Still on the launcher — the other live titles remain visible.
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Sản phẩm'), findsOneWidget);
  });
}
