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
import 'package:toastification/toastification.dart';

class _FakeRepo implements CategoryRepository {
  _FakeRepo({this.onUpdate});
  final void Function(String id, gen.CreateCategoryRequest req)? onUpdate;

  @override
  Future<ApiResult<gen.CreateCategoryResponse>> create(
    gen.CreateCategoryRequest req,
  ) => throw UnimplementedError();

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
  }) async {
    onUpdate?.call(categoryId, update);
    return ApiResult.success(
      gen.UpdateCategoryResponse((b) => b..categoryId = categoryId),
    );
  }

  @override
  Future<ApiResult<void>> remove(List<String> ids) async =>
      ApiResult.success(null);
}

void main() {
  testWidgets(
    'kebab → Edit → rename → Save calls repo.update with right shape',
    (tester) async {
      String? capturedId;
      gen.CreateCategoryRequest? capturedReq;
      final fake = _FakeRepo(
        onUpdate: (id, req) {
          capturedId = id;
          capturedReq = req;
        },
      );

      final cat = gen.CategoryResponse(
        (b) => b
          ..categoryId = 'cat-1'
          ..name = 'Old name'
          ..layer = '1'
          ..status = 'ACTIVE'
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
          child: ToastificationWrapper(
            child: MaterialApp(
              theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              home: const CategoriesListScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Open the kebab action sheet.
      await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap "Edit" in the action sheet.
      await tester.tap(find.text('Edit'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // The Name field is pre-filled with 'Old name'. Replace it.
      // TextField[0] is the list screen's KSearchBar; the sheet's name
      // KTextField is TextField[1].
      final field = find.byType(TextField).at(1);
      await tester.tap(field);
      await tester.pump();
      (tester.widget(field) as TextField).controller!.clear();
      await tester.enterText(field, 'New name');
      await tester.pump();

      // Tap Save.
      await tester.tap(find.text('Save'));
      await tester.pump(); // process tap + setState(_busy=true)
      await tester.pump(); // flush async microtasks from _submit()
      await tester.pump(); // flush invalidate + setState(_busy=false)
      await tester.pump(
        const Duration(milliseconds: 300),
      ); // sheet close animation

      expect(capturedId, 'cat-1');
      expect(capturedReq?.name, 'New name');
      expect(capturedReq?.layer, '1');
      expect(capturedReq?.status, 'ACTIVE');
      // Drain toastification 4s auto-close timer before disposal.
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
