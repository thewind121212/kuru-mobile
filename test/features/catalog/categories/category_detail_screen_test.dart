import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
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
    ..orgId = 'org'
    ..itemCount = 0
    ..totalValue = 0
    ..lowStockCount = 0
    ..subCategoriesCount = 0,
);

void main() {
  testWidgets('renders header (name) + child rows when overview has them', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryByIdProvider(
            'root',
          ).overrideWith((ref) async => _cat(id: 'root', name: 'Electronics')),
          categoryOverviewProvider.overrideWith(
            (ref) async => [
              _cat(id: 'root', name: 'Electronics'),
              _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
              _cat(id: 'c2', name: 'Mobile', layer: '2', parentId: 'root'),
            ],
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CategoryDetailScreen(categoryId: 'root'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Electronics'), findsWidgets);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });
}
