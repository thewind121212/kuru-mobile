import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';

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
}
