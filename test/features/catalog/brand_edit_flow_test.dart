import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

class _MockRepo extends Mock implements BrandRepository {}

gen.BrandOverviewItem _b(String name) => gen.BrandOverviewItem(
  (b) => b
    ..id = 'b1'
    ..orgId = 'org-1'
    ..name = name
    ..productCount = 0,
);

void main() {
  testWidgets('row tap → edit sheet → save → list updates + SnackBar', (
    tester,
  ) async {
    final repo = _MockRepo();
    var callCount = 0;
    when(repo.getOverview).thenAnswer((_) async {
      callCount++;
      return ApiResult.success([_b(callCount == 1 ? 'Nike' : 'Nike Air Max')]);
    });
    when(
      () => repo.update(brandId: 'b1', name: 'Nike Air Max'),
    ).thenAnswer((_) async => ApiResult.success(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [brandRepositoryProvider.overrideWithValue(repo)],
        child: ToastificationWrapper(
          child: MaterialApp(
            theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
            locale: const Locale('vi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const BrandsListScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the row body (not the kebab).
    await tester.tap(find.text('Nike'));
    await tester.pumpAndSettle(); // wait for bottom-sheet slide-in animation

    // Sheet open, name prefilled. Replace the text in the form field.
    // Scope to BottomSheet to avoid hitting the search bar behind it.
    final field = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'Nike Air Max');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Cập nhật'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.update(brandId: 'b1', name: 'Nike Air Max')).called(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Nike Air Max'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });
}
