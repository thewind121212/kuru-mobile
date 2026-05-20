// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

class _FakeRepo implements CategoryRepository {
  List<String>? removed;

  @override
  Future<ApiResult<gen.CreateCategoryResponse>> create(
    gen.CreateCategoryRequest req,
  ) => throw UnimplementedError();

  @override
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview({int depth = 5}) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.CategoryResponse>> getById(String id) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.UpdateCategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<void>> remove(List<String> ids) async {
    removed = ids;
    return ApiResult.success(null);
  }
}

void main() {
  testWidgets('kebab → Delete → Confirm calls remove with [id]', (
    tester,
  ) async {
    final fake = _FakeRepo();
    final cat = gen.CategoryResponse(
      (b) => b
        ..categoryId = 'cat-1'
        ..name = 'Electronics'
        ..layer = '1'
        ..orgId = 'o'
        ..itemCount = 0
        ..totalValue = 0
        ..lowStockCount = 0
        ..subCategoriesCount = 0,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryRepositoryProvider.overrideWithValue(fake),
          categoryOverviewProvider.overrideWith((ref) async => [cat]),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CategoriesListScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the kebab on the card.
    await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Delete" in the action sheet.
    await tester.tap(find.text('Delete').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Delete" in the confirm dialog (the second Delete on screen).
    await tester.tap(find.text('Delete').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(fake.removed, ['cat-1']);
  });
}
