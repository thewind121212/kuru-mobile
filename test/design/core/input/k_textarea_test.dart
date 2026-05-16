import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KTextarea renders label and accepts text', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextarea(
      label: 'Description',
      controller: ctl,
    )));
    await tester.pump();

    expect(find.text('Description'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'A nice category');
    expect(ctl.text, 'A nice category');
  });

  testWidgets('KTextarea respects maxLines', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextarea(
      label: 'Description',
      controller: ctl,
      minLines: 2,
      maxLines: 5,
    )));
    await tester.pump();
    final tf = tester.widget<TextField>(find.byType(TextField));
    expect(tf.minLines, 2);
    expect(tf.maxLines, 5);
  });

  testWidgets(
    'KTextarea shows counter when maxLength is set',
    (tester) async {
      final ctl = TextEditingController(text: 'abc');
      addTearDown(ctl.dispose);
      await tester.pumpWidget(wrap(KTextarea(
        label: 'Description',
        controller: ctl,
        maxLength: 100,
      )));
      await tester.pump();
      expect(find.text('3/100'), findsOneWidget);
    },
  );

  testWidgets('KTextarea renders error text', (tester) async {
    final ctl = TextEditingController();
    addTearDown(ctl.dispose);
    await tester.pumpWidget(wrap(KTextarea(
      label: 'Description',
      controller: ctl,
      errorText: 'Too short',
    )));
    await tester.pump();
    expect(find.text('Too short'), findsOneWidget);
  });
}
