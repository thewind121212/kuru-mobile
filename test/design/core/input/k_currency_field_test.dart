// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  // The sheet hero is tagged with this key so tests can distinguish it
  // from same-looking text in the trigger row or in the number pad.
  const heroKey = ValueKey('currencyHero');
  String heroText(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(heroKey)).data!;
  Finder padDigit(int d) => find.byKey(ValueKey('padKey-$d'));

  group('KCurrencyField trigger row', () {
    testWidgets('renders label + formatted value + suffix', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: 40000, onChanged: (_) {})),
      );
      await tester.pump();

      expect(find.text('Giá bán'), findsOneWidget);
      // Trigger row shows formatted value.
      expect(find.text('40.000'), findsOneWidget);
      // Suffix is rendered next to it.
      expect(find.text('đ'), findsWidgets);
    });

    testWidgets('renders placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: null, onChanged: (_) {})),
      );
      await tester.pump();

      expect(find.text('Nhập số tiền'), findsOneWidget);
    });

    testWidgets('renders error text when errorText is set', (tester) async {
      await tester.pumpWidget(
        wrap(
          KCurrencyField(
            label: 'Giá bán',
            value: 1000,
            errorText: 'Bắt buộc',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Bắt buộc'), findsOneWidget);
    });

    testWidgets('tapping trigger opens the bottom sheet', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: 40000, onChanged: (_) {})),
      );
      await tester.pump();

      await tester.tap(find.byType(KCurrencyField));
      // Bottom sheet animates in; step through frames.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Sheet shows the centered label and "Lưu" button.
      expect(find.text('Lưu'), findsOneWidget);
      // The label appears in both trigger row and sheet, hence "findsWidgets".
      expect(find.text('Giá bán'), findsWidgets);
    });
  });

  group('KCurrencyField number pad', () {
    testWidgets('tapping 4-0-0-0-0 builds 40.000 in the hero', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: null, onChanged: (_) {})),
      );
      await tester.pump();

      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(padDigit(4));
      await tester.pump();
      for (var i = 0; i < 4; i++) {
        await tester.tap(padDigit(0));
        await tester.pump();
      }

      expect(heroText(tester), '40.000');
    });

    testWidgets('000 button appends three zeros', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: null, onChanged: (_) {})),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(padDigit(5));
      await tester.pump();
      await tester.tap(find.text('000'));
      await tester.pump();

      expect(heroText(tester), '5.000');
    });

    testWidgets('backspace pops last digit', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: 123, onChanged: (_) {})),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Hero shows the initial value.
      expect(heroText(tester), '123');
      await tester.tap(find.byIcon(TablerIcons.backspace));
      await tester.pump();
      expect(heroText(tester), '12');
    });

    testWidgets('backspace on empty is a no-op (sheet stays open)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: null, onChanged: (_) {})),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Initial value is 0 → backspace must NOT close the sheet.
      await tester.tap(find.byIcon(TablerIcons.backspace));
      await tester.pump();
      // The "Lưu" button is still visible, proving the sheet stays open.
      expect(find.text('Lưu'), findsOneWidget);
      // Hero still shows 0.
      expect(heroText(tester), '0');
    });
  });

  group('KCurrencyField quick-fill chips', () {
    testWidgets('×10 chip multiplies current value by 10', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: 4000, onChanged: (_) {})),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('×10'));
      await tester.pump();

      expect(heroText(tester), '40.000');
    });

    testWidgets('reduction percent chips set amount from reference price', (
      tester,
    ) async {
      final received = <int?>[];
      await tester.pumpWidget(
        wrap(
          KCurrencyField(
            label: 'Số tiền giảm',
            value: 0,
            allowZero: true,
            previewBaseValue: 100000,
            previewZeroText: 'Bấm để giảm',
            reductionReferenceValue: 100000,
            reductionPercents: const [1, 5, 10],
            hideMultipliers: true,
            onChanged: received.add,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Giảm 5%'));
      await tester.pump();
      expect(heroText(tester), '-5.000');

      await tester.tap(find.text('Lưu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(received, equals([5000]));
    });
  });

  group('KCurrencyField commit / cancel', () {
    testWidgets('Lưu pops with int; onChanged fires once with new value', (
      tester,
    ) async {
      final received = <int?>[];
      await tester.pumpWidget(
        wrap(
          KCurrencyField(
            label: 'Giá bán',
            value: 1000,
            onChanged: received.add,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Append a digit: 1000 → 10000.
      await tester.tap(padDigit(0));
      await tester.pump();
      await tester.tap(find.text('Lưu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(received, equals([10000]));
    });

    testWidgets('X button pops with null; onChanged does NOT fire', (
      tester,
    ) async {
      final received = <int?>[];
      await tester.pumpWidget(
        wrap(
          KCurrencyField(
            label: 'Giá bán',
            value: 1000,
            onChanged: received.add,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap a digit (changes sheet state), then dismiss via X.
      await tester.tap(padDigit(5));
      await tester.pump();
      await tester.tap(find.byIcon(TablerIcons.x));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(received, isEmpty);
    });
  });

  group('KCurrencyField 12-digit cap', () {
    testWidgets('13th digit tap is rejected', (tester) async {
      await tester.pumpWidget(
        wrap(KCurrencyField(label: 'Giá bán', value: null, onChanged: (_) {})),
      );
      await tester.pump();
      await tester.tap(find.byType(KCurrencyField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Build 999999999999 (12 nines), then try to add a 13th.
      for (var i = 0; i < 12; i++) {
        await tester.tap(padDigit(9));
        await tester.pump();
      }
      // 12 nines formatted: 999.999.999.999
      expect(heroText(tester), '999.999.999.999');

      // 13th tap must be rejected — value stays the same.
      await tester.tap(padDigit(9));
      await tester.pump();
      expect(heroText(tester), '999.999.999.999');
    });
  });
}
