import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_archive_dialog.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ProductRepository {}

MaterialApp _harness(Widget child) => MaterialApp(
  theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
  home: child,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const UpdateProductInfoBody(productId: '_'));
  });

  testWidgets('confirm calls updateInfo(status=ARCHIVED)', (t) async {
    final repo = _MockRepo();
    when(
      () => repo.updateInfo(any()),
    ).thenAnswer((_) async => ApiResult<void>.success(null));

    await t.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repo)],
        child: _harness(
          Builder(
            builder: (ctx) => Scaffold(
              body: ElevatedButton(
                onPressed: () =>
                    showProductArchiveDialog(ctx, productId: 'p-1'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await t.tap(find.text('open'));
    await t.pump();
    expect(find.text('Ngừng kinh doanh sản phẩm?'), findsOneWidget);
    await t.tap(find.text('Ngừng kinh doanh'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));

    final captured =
        verify(() => repo.updateInfo(captureAny())).captured.single
            as UpdateProductInfoBody;
    expect(captured.productId, 'p-1');
    expect(captured.status, 'ARCHIVED');
    // Drain toastification 4s auto-close timer before disposal.
    await t.pump(const Duration(seconds: 5));
  });

  testWidgets('returns false on failure', (t) async {
    final repo = _MockRepo();
    when(() => repo.updateInfo(any())).thenAnswer(
      (_) async => ApiResult.failure(const NetworkException('offline')),
    );

    bool? result;
    await t.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repo)],
        child: _harness(
          Builder(
            builder: (ctx) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await showProductArchiveDialog(
                    ctx,
                    productId: 'p-1',
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('open'));
    await t.pump();
    await t.tap(find.text('Ngừng kinh doanh'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));
    expect(result, false);
    // Drain toastification 4s auto-close timer before disposal.
    await t.pump(const Duration(seconds: 5));
  });
}
