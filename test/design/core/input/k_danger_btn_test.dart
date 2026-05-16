import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_danger_btn.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KDangerBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(KDangerBtn(
      label: 'Delete',
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KDangerBtn));
    expect(tapped, 1);
  });

  testWidgets(
    'KDangerBtn loading=true suppresses onPressed',
    (tester) async {
      var tapped = 0;
      await tester.pumpWidget(wrap(KDangerBtn(
        label: 'Delete',
        loading: true,
        onPressed: () => tapped++,
      )));
      await tester.pump();
      await tester.tap(find.byType(KDangerBtn));
      expect(tapped, 0);
    },
  );

  testWidgets('KDangerBtn renders label', (tester) async {
    await tester.pumpWidget(wrap(KDangerBtn(
      label: 'Delete',
      onPressed: () {},
    )));
    await tester.pump();
    expect(find.text('Delete'), findsOneWidget);
  });
}
