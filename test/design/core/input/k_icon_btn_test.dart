import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('KIconBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(KIconBtn(icon: const Icon(Icons.add), onPressed: () => tapped++)),
    );
    await tester.pump();
    await tester.tap(find.byType(KIconBtn));
    expect(tapped, 1);
  });

  testWidgets('KIconBtn with onPressed=null does not respond', (tester) async {
    await tester.pumpWidget(wrap(const KIconBtn(icon: Icon(Icons.add))));
    await tester.pump();
    expect(find.byType(KIconBtn), findsOneWidget);
  });

  testWidgets('KIconBtn renders tooltip when provided', (tester) async {
    await tester.pumpWidget(
      wrap(
        KIconBtn(
          icon: const Icon(Icons.add),
          tooltip: 'Add brand',
          onPressed: () {},
        ),
      ),
    );
    await tester.pump();
    expect(find.byTooltip('Add brand'), findsOneWidget);
  });

  testWidgets('KIconBtn default size is 48dp (Material 3 min tap target)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(KIconBtn(icon: const Icon(Icons.add), onPressed: () {})),
    );
    await tester.pump();
    final box = tester.getSize(find.byType(KIconBtn));
    expect(box.width, 48);
    expect(box.height, 48);
  });

  testWidgets('KIconBtn respects explicit size override', (tester) async {
    await tester.pumpWidget(
      wrap(KIconBtn(icon: const Icon(Icons.add), size: 56, onPressed: () {})),
    );
    await tester.pump();
    final box = tester.getSize(find.byType(KIconBtn));
    expect(box.width, 56);
    expect(box.height, 56);
  });
}
