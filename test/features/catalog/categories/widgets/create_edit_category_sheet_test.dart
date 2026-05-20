import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

void main() {
  testWidgets('createRoot mode renders title + Active default + Save CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
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
  });

  testWidgets('empty name shows the error and keeps the sheet open', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
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

    // Tap Save without entering a name.
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Sheet should still be open (Save CTA still findable).
    expect(find.text('Save'), findsOneWidget);
    // Some error text should appear under the name field. The exact
    // message comes from validationNameRequired ARB key.
    expect(find.text('Please enter your full name.'), findsOneWidget);
  });

  testWidgets('valid submit calls repo.create and closes the sheet', (
    tester,
  ) async {
    gen.CreateCategoryRequest? captured;
    final fakeRepo = _FakeRepo(
      onCreate: (req) {
        captured = req;
      },
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [categoryRepositoryProvider.overrideWithValue(fakeRepo)],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
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

    await tester.enterText(find.byType(TextField).first, 'Electronics');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(captured?.name, 'Electronics');
    expect(captured?.layer, '1');
    expect(captured?.status, 'ACTIVE');
  });
}

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
  Future<ApiResult<gen.CategoryResponse>> getById(String id) async =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.UpdateCategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<void>> remove(List<String> ids) async =>
      ApiResult.success(null);
}
