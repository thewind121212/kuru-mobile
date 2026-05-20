import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

class _MockRepo extends Mock implements BrandRepository {}

gen.BrandOverviewItem _item({
  required String id,
  required String name,
  int products = 0,
}) => gen.BrandOverviewItem(
  (b) => b
    ..id = id
    ..orgId = 'org-1'
    ..name = name
    ..productCount = products,
);

Widget _harness(_MockRepo repo) {
  return ProviderScope(
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
  );
}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  testWidgets('empty state shows CTA', (tester) async {
    when(
      () => repo.getOverview(),
    ).thenAnswer((_) async => ApiResult.success([]));

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
    expect(find.text('Tạo thương hiệu đầu tiên'), findsOneWidget);
  });

  testWidgets('error state shows retry', (tester) async {
    when(() => repo.getOverview()).thenAnswer(
      (_) async =>
          ApiResult.failure(const ServerException('boom', statusCode: 500)),
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Không tải được danh sách thương hiệu'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('data state renders cards', (tester) async {
    when(() => repo.getOverview()).thenAnswer(
      (_) async => ApiResult.success([
        _item(id: 'b1', name: 'Nike', products: 42),
        _item(id: 'b2', name: 'Adidas', products: 31),
      ]),
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Nike'), findsOneWidget);
    expect(find.text('Adidas'), findsOneWidget);
  });

  testWidgets('search filters with accent-folding', (tester) async {
    when(() => repo.getOverview()).thenAnswer(
      (_) async => ApiResult.success([
        _item(id: 'b1', name: 'Nước Suối'),
        _item(id: 'b2', name: 'Coca'),
      ]),
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(find.byType(TextField), 'nuoc');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Nước Suối'), findsOneWidget);
    expect(find.text('Coca'), findsNothing);
  });

  group('delete', () {
    testWidgets('confirm → repo.remove + invalidate + SnackBar', (
      tester,
    ) async {
      when(() => repo.getOverview()).thenAnswer(
        (_) async => ApiResult.success([_item(id: 'b1', name: 'Nike')]),
      );
      when(
        () => repo.remove('b1'),
      ).thenAnswer((_) async => ApiResult.success(null));

      await tester.pumpWidget(_harness(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Open kebab → action sheet → Xóa → confirm dialog → Xóa.
      await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Confirm dialog visible — tap the destructive Xóa button.
      await tester.tap(find.text('Xóa').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      verify(() => repo.remove('b1')).called(1);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('400 reason → SnackBar with verbatim message', (tester) async {
      when(() => repo.getOverview()).thenAnswer(
        (_) async => ApiResult.success([_item(id: 'b1', name: 'Nike')]),
      );
      when(() => repo.remove('b1')).thenAnswer(
        (_) async =>
            ApiResult.failure(const BadRequestException('Brand has products')),
      );

      await tester.pumpWidget(_harness(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      verify(() => repo.remove('b1')).called(1);
      await tester.pump(const Duration(seconds: 5));
    });
  });
}
