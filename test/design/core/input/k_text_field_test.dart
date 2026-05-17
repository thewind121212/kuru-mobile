import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KTextField renders label', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextField(
      label: 'Brand name',
      controller: ctl,
    )));
    await tester.pump();
    expect(find.text('Brand name'), findsOneWidget);
  });

  testWidgets('KTextField updates controller on type', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextField(
      label: 'Brand name',
      controller: ctl,
    )));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Coffee');
    expect(ctl.text, 'Coffee');
  });

  testWidgets(
    'KTextField shows error text when errorText is non-null',
    (tester) async {
      final ctl = TextEditingController();
      addTearDown(ctl.dispose);
      await tester.pumpWidget(wrap(KTextField(
        label: 'Brand name',
        controller: ctl,
        errorText: 'Name is required',
      )));
      await tester.pump();
      expect(find.text('Name is required'), findsOneWidget);
    },
  );

  testWidgets('KTextField obscureText hides characters', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextField(
      label: 'Password',
      controller: ctl,
      obscureText: true,
    )));
    await tester.pump();
    final tf = tester.widget<TextField>(find.byType(TextField));
    expect(tf.obscureText, isTrue);
  });
}
