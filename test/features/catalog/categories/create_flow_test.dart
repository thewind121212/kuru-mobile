// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  _FakeRepo({this.onCreate});
  final void Function(gen.CreateCategoryRequest)? onCreate;

  @override
  Future<ApiResult<gen.CreateCategoryResponse>> create(
    gen.CreateCategoryRequest req,
  ) async {
    onCreate?.call(req);
    return ApiResult.success(
      gen.CreateCategoryResponse((b) => b..categoryId = 'new-id'),
    );
  }

  @override
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview({
    int depth = 5,
  }) async => ApiResult.success(const []);

  @override
  Future<ApiResult<gen.CategoryResponse>> getById(String id) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.UpdateCategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<void>> remove(List<String> ids) async =>
      ApiResult.success(null);
}

void main() {
  testWidgets('+ → fill name → Save calls repo.create with right shape', (
    tester,
  ) async {
    gen.CreateCategoryRequest? captured;
    final fake = _FakeRepo(onCreate: (req) => captured = req);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryRepositoryProvider.overrideWithValue(fake),
          categoryOverviewProvider.overrideWith((ref) async => []),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const CategoriesListScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the header "+" button. Tooltip is the localized
    // categoryCreateTitle ("New category" / "Danh mục mới").
    await tester.tap(find.byTooltip('New category'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Fill the Name field. The list screen's KSearchBar is TextField[0];
    // the sheet's name KTextField is TextField[1].
    await tester.enterText(find.byType(TextField).at(1), 'Electronics');
    await tester.pump();

    // Tap the Save CTA (KModalSheet footer).
    await tester.tap(find.text('Save'));
    await tester.pump(); // process tap + setState(_busy=true)
    await tester.pump(); // flush async microtasks from _submit()
    await tester.pump(); // flush invalidate + setState(_busy=false)
    await tester.pump(
      const Duration(milliseconds: 300),
    ); // sheet close animation

    expect(captured?.name, 'Electronics');
    expect(captured?.layer, '1');
    expect(captured?.status, 'ACTIVE');
    // parentId for createRoot is NIL_UUID.
    expect(captured?.parentId, '00000000-0000-0000-0000-000000000000');
  });
}
