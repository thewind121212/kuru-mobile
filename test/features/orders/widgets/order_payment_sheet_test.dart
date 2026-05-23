import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_sheet.dart';

void main() {
  testWidgets('returns OrderPaymentInput with default amount + chosen method', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    OrderPaymentInput? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showOrderPaymentSheet(
                    ctx,
                    defaultAmount: 50000,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Confirm with default amount + default method (cash)
    final confirm = find.text('Xác nhận');
    await tester.tap(confirm);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(result, isNotNull);
    expect(result!.method, OrderPaymentMethod.cash);
    expect(result!.amount, 50000);
  });
}
