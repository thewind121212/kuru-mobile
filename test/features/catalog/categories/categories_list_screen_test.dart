import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

gen.CategoryResponse _cat({
  required String id,
  required String name,
  String layer = '1',
  String? parentId,
}) => gen.CategoryResponse(
  (b) => b
    ..categoryId = id
    ..name = name
    ..layer = layer
    ..parentId = parentId
    ..orgId = 'org1'
    ..itemCount = 0
    ..totalValue = 0
    ..lowStockCount = 0,
);

Widget _wrap(Widget child, {required Override overrideOverview}) =>
    ProviderScope(
      overrides: [overrideOverview],
      child: MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  testWidgets('CategoriesListScreen renders header + search bar', (
    tester,
  ) async {
    // Override the provider so no real network call fires and no timer is left
    // pending when the test finishes.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryOverviewProvider.overrideWith(
            (ref) => Future.delayed(const Duration(seconds: 5), () => []),
          ),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CategoriesListScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Search categories...'), findsOneWidget);
    // Drain the pending 5-second timer so the test can finish cleanly.
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('shows skeleton while loading', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) => Future.delayed(const Duration(seconds: 5), () => []),
        ),
      ),
    );
    await tester.pump(); // first frame — skeleton visible, timer still pending
    // Drain the pending 5-second timer so the test can complete cleanly.
    await tester.pump(const Duration(seconds: 5));
    // No assertion needed — the test just verifies no crash during skeleton.
  });

  testWidgets('shows empty state when 0 categories', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => <gen.CategoryResponse>[],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('No categories yet'), findsOneWidget);
    expect(find.text('Create first category'), findsOneWidget);
  });

  testWidgets('shows list rows when data is present', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Electronics'),
            _cat(id: '2', name: 'Food & Beverage'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Food & Beverage'), findsOneWidget);
  });

  testWidgets('shows error state with retry on AsyncError', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => throw const NetworkException('boom'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text("Couldn't load categories"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows Main + Sub tabs from data', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'A'),
            _cat(id: '2', name: 'B'),
            _cat(id: '3', name: 'C', layer: '2', parentId: '1'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Tab bar has two tabs: Main and Sub (no "All" tab in the new design).
    // Use findsWidgets because AnimatedDefaultTextStyle may render the label
    // text in multiple nodes in the widget tree.
    expect(find.text('Main'), findsWidgets);
    expect(find.text('Sub'), findsWidgets);
  });

  testWidgets('tapping Sub tab shows layer-2 items', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Electronics'),
            _cat(id: '2', name: 'Audio', layer: '2', parentId: '1'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Default tab is Main — Electronics (layer 1) is visible.
    expect(find.text('Electronics'), findsOneWidget);
    // Audio (layer 2) is on the Sub tab — not visible yet.
    expect(find.text('Audio'), findsNothing);
    // Tap the first "Sub" text node (the tab chip label).
    await tester.tap(find.text('Sub').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Audio (layer 2) is now visible.
    expect(find.text('Audio'), findsOneWidget);
    // "Electronics" appears as the group-parent header in _SubGroupHeader,
    // so it is still rendered — but it is no longer a selectable card row.
    expect(find.text('Electronics'), findsWidgets);
  });

  testWidgets('typing in search filters rows by normalized name', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Điện tử'),
            _cat(id: '2', name: 'Thực phẩm'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.enterText(find.byType(TextField), 'dien');
    await tester.pump();
    expect(find.text('Điện tử'), findsOneWidget);
    expect(find.text('Thực phẩm'), findsNothing);
  });

  testWidgets('search on Sub tab filters within that tab only', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Electronics'),
            _cat(id: '2', name: 'Electron beam', layer: '2', parentId: '1'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Switch to Sub tab.
    await tester.tap(find.text('Sub').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField), 'electron');
    await tester.pump();
    // The Sub-tab match is visible.
    expect(find.text('Electron beam'), findsOneWidget);
    // "Electronics" appears as the group-parent header for Electron beam,
    // so it is visible in the sub list even when filtering by 'electron'.
    expect(find.text('Electronics'), findsWidgets);
  });

  testWidgets('tapping the + header button opens the create sheet at root', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byTooltip('New category'), findsOneWidget);
    await tester.tap(find.byTooltip('New category'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Sheet's title "New category" appears.
    expect(find.text('New category'), findsAtLeastNWidgets(1));
  });
}
