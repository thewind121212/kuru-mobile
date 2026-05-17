import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';

void main() {
  testWidgets('CategoryDetailScreen shows the placeholder text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CategoryDetailScreen(categoryId: 'abc'),
        ),
      ),
    );
    expect(find.text('Detail view coming soon'), findsOneWidget);
  });
}
