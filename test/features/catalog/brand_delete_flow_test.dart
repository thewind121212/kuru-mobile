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

void main() {
  testWidgets('long-press → action sheet → Xóa → confirm → list refreshes', (
    tester,
  ) async {
    final repo = _MockRepo();
    var callCount = 0;
    when(repo.getOverview).thenAnswer((_) async {
      callCount++;
      if (callCount == 1) {
        return ApiResult.success([
          gen.BrandOverviewItem(
            (b) => b
              ..id = 'b1'
              ..orgId = 'org-1'
              ..name = 'Nike'
              ..productCount = 0,
          ),
        ]);
      }
      return ApiResult.success(const <gen.BrandOverviewItem>[]);
    });
    when(
      () => repo.remove('b1'),
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

    // Long-press the row.
    await tester.longPress(find.text('Nike'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Action sheet → tap Xóa.
    await tester.tap(find.text('Xóa').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Confirm dialog → tap destructive Xóa.
    await tester.tap(find.text('Xóa').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.remove('b1')).called(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });
}
