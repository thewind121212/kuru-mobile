import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KSecondaryBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(KSecondaryBtn(
      label: 'Cancel',
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 1);
  });

  testWidgets('KSecondaryBtn loading=true suppresses onPressed',
      (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(KSecondaryBtn(
      label: 'Save',
      loading: true,
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 0);
  });

  testWidgets('KSecondaryBtn with onPressed=null is disabled', (tester) async {
    const tapped = 0;
    await tester.pumpWidget(wrap(const KSecondaryBtn(label: 'Save')));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 0);
  });

  testWidgets('KSecondaryBtn renders label', (tester) async {
    await tester.pumpWidget(wrap(KSecondaryBtn(
      label: 'Cancel',
      onPressed: () {},
    )));
    await tester.pump();
    expect(find.text('Cancel'), findsOneWidget);
  });
}
