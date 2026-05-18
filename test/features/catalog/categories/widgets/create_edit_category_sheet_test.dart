import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

void main() {
  testWidgets(
    'createRoot mode renders the "New category" title + Active default + Save CTA',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => showCreateEditCategorySheet(
                      context: context,
                      mode: const CreateRoot(),
                    ),
                    child: const Text('Open'),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('New category'), findsOneWidget); // sheet title
      expect(find.text('Active'), findsOneWidget); // default status
      expect(find.text('Save'), findsOneWidget); // confirm CTA
    },
  );
}
