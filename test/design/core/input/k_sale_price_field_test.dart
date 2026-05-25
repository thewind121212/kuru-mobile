// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_sale_price_field.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  testWidgets('renders direct price input without chips when no reference', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(KSalePriceField(label: 'Giá bán', value: 100000, onChanged: (_) {})),
    );

    expect(find.text('Giá bán'), findsOneWidget);
    expect(find.text('100.000'), findsOneWidget);
    expect(find.text('Giảm 10%'), findsNothing);
  });

  testWidgets('sale chip writes reduced price from input sheet', (
    tester,
  ) async {
    final received = <int?>[];
    await tester.pumpWidget(
      wrap(
        KSalePriceField(
          label: 'Giá bán',
          value: 100000,
          referenceValue: 100000,
          onChanged: received.add,
        ),
      ),
    );

    await tester.tap(find.byType(KSalePriceField));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Giảm 10%'));
    await tester.pump();
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('currencyHero'))).data,
      '90.000',
    );

    await tester.tap(find.text('Lưu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(received, [90000]);
  });

  testWidgets('shows reduction summary when current price is lower', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        KSalePriceField(
          label: 'Giá bán',
          value: 90000,
          referenceValue: 100000,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.textContaining('Giá cũ 100.000đ'), findsOneWidget);
    expect(find.text('-10.000đ (10%)'), findsOneWidget);
  });
}
