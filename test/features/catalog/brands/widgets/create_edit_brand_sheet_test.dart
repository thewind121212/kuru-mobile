import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/create_edit_brand_sheet.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

/// Harness with an "Open" button that calls [showCreateEditBrandSheet]
/// and stores the return value in [returned].
Widget _harness(
  _MockRepo repo,
  BrandSheetMode mode, {
  required ValueNotifier<bool?> returned,
}) {
  return ProviderScope(
    overrides: [brandRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              returned.value = await showCreateEditBrandSheet(
                context: context,
                mode: mode,
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

gen.BrandOverviewItem _existing() => gen.BrandOverviewItem(
  (b) => b
    ..id = 'b1'
    ..orgId = 'org-1'
    ..name = 'Nike'
    ..productCount = 0,
);

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  group('create', () {
    testWidgets('empty name → required errorText, stays open', (tester) async {
      final repo = _MockRepo();
      final returned = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        _harness(repo, const CreateBrand(), returned: returned),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tạo'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Tên thương hiệu là bắt buộc'), findsOneWidget);
      verifyNever(() => repo.create(name: any(named: 'name')));
    });

    testWidgets('success → closes with true', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.create(name: 'Nike'),
      ).thenAnswer((_) async => ApiResult.success('new-id'));

      final returned = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        _harness(repo, const CreateBrand(), returned: returned),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField).first, 'Nike');
      await tester.tap(find.text('Tạo'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(returned.value, isTrue);
      verify(() => repo.create(name: 'Nike')).called(1);
    });

    testWidgets('400 dup-name → errorText surfaces verbatim, stays open', (
      tester,
    ) async {
      final repo = _MockRepo();
      when(() => repo.create(name: 'Nike')).thenAnswer(
        (_) async => ApiResult.failure(
          const BadRequestException('Brand with this name already exists'),
        ),
      );

      final returned = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        _harness(repo, const CreateBrand(), returned: returned),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField).first, 'Nike');
      await tester.tap(find.text('Tạo'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Brand with this name already exists'), findsOneWidget);
    });
  });

  group('edit', () {
    testWidgets('prefills name field', (tester) async {
      final repo = _MockRepo();
      final returned = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        _harness(repo, EditBrand(brand: _existing()), returned: returned),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Nike'), findsWidgets);
    });

    testWidgets('success → closes with true + calls update', (tester) async {
      final repo = _MockRepo();
      when(
        () => repo.update(brandId: 'b1', name: 'Nike v2'),
      ).thenAnswer((_) async => ApiResult.success(null));

      final returned = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        _harness(repo, EditBrand(brand: _existing()), returned: returned),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField).first, 'Nike v2');
      await tester.tap(find.text('Cập nhật'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(returned.value, isTrue);
      verify(() => repo.update(brandId: 'b1', name: 'Nike v2')).called(1);
    });
  });
}
