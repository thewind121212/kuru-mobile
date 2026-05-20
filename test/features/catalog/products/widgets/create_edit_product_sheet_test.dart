import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/json_optional.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/create_edit_product_sheet.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ProductRepository {}

ProductDetail _existing() => const ProductDetail(
  id: 'p-1',
  name: 'Cà phê đen',
  status: ProductStatus.active,
  baseUnitCode: 'each',
  sellPrice: 25000,
  demandStock: 0,
  avgCost: 0,
  totalCostValue: 0,
  totalQtyImported: 0,
  categoryId: 'cat-1',
  brandId: 'b-1',
  brandName: 'Trung Nguyên',
  description: 'Black coffee',
);

/// Wraps the sheet body in a plain [MaterialApp] (no GoRouter required —
/// the sheet now returns `Future<String?>` via `Navigator.pop` and leaves
/// all post-create navigation to the caller).
Widget _wrapBody({
  required _MockRepo repo,
  required GlobalKey<CreateEditProductSheetBodyState> formKey,
  ProductDetail? initial,
}) {
  return ProviderScope(
    overrides: [productRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: Scaffold(
        body: CreateEditProductSheetBody(
          key: formKey,
          title: initial == null ? 'Tạo sản phẩm' : 'Sửa sản phẩm',
          initial: initial,
        ),
      ),
    ),
  );
}

bool _saveEnabled(WidgetTester t) {
  final btn = t.widget<FilledButton>(find.widgetWithText(FilledButton, 'Lưu'));
  return btn.onPressed != null;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateProductBody(name: '_', baseUnitCode: '_', sellPrice: 0),
    );
    registerFallbackValue(const UpdateProductInfoBody(productId: '_'));
  });

  testWidgets('create — Lưu is disabled on a fresh empty form', (t) async {
    final repo = _MockRepo();
    final key = GlobalKey<CreateEditProductSheetBodyState>();
    await t.pumpWidget(_wrapBody(repo: repo, formKey: key));
    await t.pump();

    // Name + sellPrice are both empty → Save must be disabled.
    expect(_saveEnabled(t), isFalse);
    verifyNever(() => repo.create(any()));
  });

  testWidgets('create — typing name + setting sellPrice enables Lưu and '
      'calls repo.create with the right body', (t) async {
    final repo = _MockRepo();
    when(
      () => repo.create(any()),
    ).thenAnswer((_) async => ApiResult.success('new-id'));

    final key = GlobalKey<CreateEditProductSheetBodyState>();
    await t.pumpWidget(_wrapBody(repo: repo, formKey: key));
    await t.pump();

    // Type the product name into KTextField.
    await t.enterText(find.byType(TextField).first, 'Trà sữa');
    // Poke sellPrice via the @visibleForTesting hook (avoids the nested
    // bottom-sheet num pad which would require driving a separate Route).
    key.currentState!.debugSetSellPrice(15000);
    await t.pump();

    expect(_saveEnabled(t), isTrue);

    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    // Settle the awaited create call. Don't pumpAndSettle (KNotify uses
    // toastification with a continuous animation).
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured =
        verify(() => repo.create(captureAny())).captured.single
            as CreateProductBody;
    expect(captured.name, 'Trà sữa');
    expect(captured.sellPrice, 15000);
    expect(captured.baseUnitCode, 'each');
    expect(captured.categoryId, isNull);
    expect(captured.brandId, isNull);
    expect(captured.description, isNull);
    // Drain toastification's auto-close timer before disposal.
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('edit — changing only name produces UpdateProductInfoBody '
      'with productId + name set and other fields null', (t) async {
    final repo = _MockRepo();
    when(
      () => repo.updateInfo(any()),
    ).thenAnswer((_) async => ApiResult<void>.success(null));

    final key = GlobalKey<CreateEditProductSheetBodyState>();
    await t.pumpWidget(
      _wrapBody(repo: repo, formKey: key, initial: _existing()),
    );
    await t.pump();

    // Untouched edit → Save stays disabled (no diff against baseline).
    expect(_saveEnabled(t), isFalse);

    await t.enterText(find.byType(TextField).first, 'Cà phê đen v2');
    await t.pump();

    expect(_saveEnabled(t), isTrue);

    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured =
        verify(() => repo.updateInfo(captureAny())).captured.single
            as UpdateProductInfoBody;
    expect(captured.productId, 'p-1');
    expect(captured.name, 'Cà phê đen v2');
    // All other fields must be null (omitted from PATCH).
    expect(captured.sellPrice, isNull);
    expect(captured.baseUnitCode, isNull);
    expect(captured.status, isNull);
    expect(captured.categoryId, isNull);
    expect(captured.brandId, isNull);
    expect(captured.description, isNull);
    expect(captured.toJson().keys, unorderedEquals(['productId', 'name']));
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('400 with "name" in message → errorText on name, no toast, '
      'sheet stays open', (t) async {
    final repo = _MockRepo();
    when(() => repo.create(any())).thenAnswer(
      (_) async => ApiResult.failure(
        const BadRequestException('Product name already exists'),
      ),
    );

    final key = GlobalKey<CreateEditProductSheetBodyState>();
    await t.pumpWidget(_wrapBody(repo: repo, formKey: key));
    await t.pump();

    await t.enterText(find.byType(TextField).first, 'Cà phê đen');
    key.currentState!.debugSetSellPrice(20000);
    await t.pump();

    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text('Product name already exists'), findsOneWidget);
    verify(() => repo.create(any())).called(1);
  });

  testWidgets('edit — clearing a previously-set category emits '
      'JsonOptional.clear()', (t) async {
    final repo = _MockRepo();
    when(
      () => repo.updateInfo(any()),
    ).thenAnswer((_) async => ApiResult<void>.success(null));

    final key = GlobalKey<CreateEditProductSheetBodyState>();
    await t.pumpWidget(
      _wrapBody(repo: repo, formKey: key, initial: _existing()),
    );
    await t.pump();

    // Clear the category via the testing hook.
    key.currentState!.debugSetCategory(null, null);
    await t.pump();

    expect(_saveEnabled(t), isTrue);
    await t.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured =
        verify(() => repo.updateInfo(captureAny())).captured.single
            as UpdateProductInfoBody;
    expect(captured.categoryId, isA<JsonOptional<String>>());
    expect(captured.categoryId!.isSet, isTrue);
    expect(captured.categoryId!.value, isNull); // .clear() → value is null
    // Brand untouched → key should be absent from JSON.
    expect(captured.brandId, isNull);
    expect(captured.toJson().containsKey('categoryId'), isTrue);
    expect(captured.toJson()['categoryId'], isNull);
    expect(captured.toJson().containsKey('brandId'), isFalse);
    await t.pump(const Duration(seconds: 5));
  });
}
