import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  testWidgets('CategoriesListScreen renders header + search bar', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CategoriesListScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Manage product classifications'), findsOneWidget);
    expect(find.text('Search categories...'), findsOneWidget);
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
    await tester.pump(); // first frame
    // The skeleton list shows multiple KSkeleton instances
    // Don't pumpAndSettle — KSkeleton animates forever.
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

  testWidgets('shows All + distinct layer tabs from data', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'A'),
            _cat(id: '2', name: 'B'),
            _cat(id: '3', name: 'C', layer: '2'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Main'), findsOneWidget);
    expect(find.text('Sub'), findsOneWidget);
  });

  testWidgets('tapping a layer tab filters the list', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Electronics'),
            _cat(id: '2', name: 'Audio', layer: '2'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Both visible under "All"
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    // Tap "Main" — should hide Audio (layer 2)
    await tester.tap(find.text('Main'));
    await tester.pump();
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Audio'), findsNothing);
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

  testWidgets('search applies within active layer, not across all', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const CategoriesListScreen(),
        overrideOverview: categoryOverviewProvider.overrideWith(
          (ref) async => [
            _cat(id: '1', name: 'Electronics'),
            _cat(id: '2', name: 'Electron beam', layer: '2'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Switch to layer 2 ("Sub")
    await tester.tap(find.text('Sub'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'electron');
    await tester.pump();
    // Only layer-2 match is visible
    expect(find.text('Electron beam'), findsOneWidget);
    expect(find.text('Electronics'), findsNothing);
  });
}
