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

class _MockRepo extends Mock implements BrandRepository {}

void main() {
  testWidgets('list → + → fill name → Tạo → list refreshes + SnackBar', (
    tester,
  ) async {
    final repo = _MockRepo();
    final initial = <gen.BrandOverviewItem>[];
    final afterCreate = [
      gen.BrandOverviewItem(
        (b) => b
          ..id = 'b1'
          ..orgId = 'org-1'
          ..name = 'Nike'
          ..productCount = 0,
      ),
    ];
    var callCount = 0;
    when(repo.getOverview).thenAnswer((_) async {
      callCount++;
      return ApiResult.success(callCount == 1 ? initial : afterCreate);
    });
    when(
      () => repo.create(name: 'Nike'),
    ).thenAnswer((_) async => ApiResult.success('b1'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [brandRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const BrandsListScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Empty state visible — tap the empty-state CTA.
    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
    await tester.tap(find.text('Tạo thương hiệu đầu tiên'));
    await tester.pumpAndSettle(); // wait for bottom-sheet slide-in animation

    // Sheet open. Fill name + tap Tạo (the sheet confirm button).
    // Use the title text 'Tạo thương hiệu' as an ancestor scope so we find
    // the form's TextField, not the search-bar TextField behind the sheet.
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'Nike',
    );
    await tester.tap(
      find.descendant(of: find.byType(BottomSheet), matching: find.text('Tạo')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.create(name: 'Nike')).called(1);
    expect(find.text('Đã lưu thương hiệu'), findsOneWidget);
    // After invalidation the overview provider refetches → second call serves
    // afterCreate.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Nike'), findsOneWidget);
  });
}
