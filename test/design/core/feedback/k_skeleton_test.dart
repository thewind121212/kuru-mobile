import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';

void main() {
  testWidgets('KSkeleton renders a Container with given size', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(
        body: Center(child: KSkeleton(width: 100, height: 12)),
      ),
    ));
    // Pulse never settles — use pump twice.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final box = tester.getSize(find.byType(KSkeleton));
    expect(box.width, 100);
    expect(box.height, 12);
  });

  testWidgets('KSkeleton.circle renders a square of given diameter',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSkeleton.circle(40))),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final box = tester.getSize(find.byType(KSkeleton));
    expect(box.width, 40);
    expect(box.height, 40);
  });

  testWidgets('KSkeleton disposes its AnimationController', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSkeleton(width: 100))),
    ));
    await tester.pump();
    // Remove the widget — pumpWidget with a different child triggers dispose.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    // If dispose were missing, the tester would print a leak error on tearDown.
    expect(find.byType(KSkeleton), findsNothing);
  });
}
