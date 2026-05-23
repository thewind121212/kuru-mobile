import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/widgets/add_line_sheet.dart';

void main() {
  testWidgets('edit mode pre-fills qty and price, returns updated line', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    OrderLineItem? result;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: Builder(
            builder: (ctx) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showAddLineSheet(
                      ctx,
                      edit: const OrderLineItem(
                        productId: 'p_1',
                        productName: 'Test',
                        baseUnitCode: 'pcs',
                        qty: 5,
                        unitPrice: 8000,
                      ),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('5'), findsOneWidget); // pre-filled qty
    expect(find.text('8000'), findsOneWidget); // pre-filled unitPrice

    // Tap update with values unchanged
    await tester.tap(find.text('Cập nhật'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(result, isNotNull);
    expect(result!.qty, 5);
    expect(result!.unitPrice, 8000);
  });
}
