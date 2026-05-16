import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KTabNav renders all tab labels', (tester) async {
    await tester.pumpWidget(wrap(KTabNav<String>(
      tabs: const [
        KTabItem(id: 'all', label: 'All'),
        KTabItem(id: 'l1', label: 'Layer 1'),
        KTabItem(id: 'l2', label: 'Layer 2'),
      ],
      active: 'all',
      onChange: (_) {},
    )));
    await tester.pump();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Layer 1'), findsOneWidget);
    expect(find.text('Layer 2'), findsOneWidget);
  });

  testWidgets(
    'KTabNav fires onChange when tapping inactive tab',
    (tester) async {
      String? captured;
      await tester.pumpWidget(wrap(KTabNav<String>(
        tabs: const [
          KTabItem(id: 'all', label: 'All'),
          KTabItem(id: 'l1', label: 'Layer 1'),
        ],
        active: 'all',
        onChange: (id) => captured = id,
      )));
      await tester.pump();
      await tester.tap(find.text('Layer 1'));
      expect(captured, 'l1');
    },
  );

  testWidgets(
    'KTabNav is horizontally scrollable when content overflows',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap(KTabNav<int>(
        tabs: List.generate(8, (i) => KTabItem(id: i, label: 'Tab $i')),
        active: 0,
        onChange: (_) {},
      )));
      await tester.pump();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    },
  );
}
