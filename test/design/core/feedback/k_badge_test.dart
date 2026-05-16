import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KBadge renders label', (tester) async {
    await tester.pumpWidget(wrap(const KBadge(label: 'Active')));
    await tester.pump();
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('KBadge renders for every tone without crash', (tester) async {
    for (final tone in KBadgeTone.values) {
      await tester.pumpWidget(wrap(KBadge(label: tone.name, tone: tone)));
      await tester.pump();
      expect(find.text(tone.name), findsOneWidget);
    }
  });

  testWidgets('KBadge renders leading icon when provided', (tester) async {
    await tester.pumpWidget(wrap(const KBadge(
      label: 'Low stock',
      tone: KBadgeTone.danger,
      leadingIcon: Icons.warning,
    )));
    await tester.pump();
    expect(find.byIcon(Icons.warning), findsOneWidget);
    expect(find.text('Low stock'), findsOneWidget);
  });
}
