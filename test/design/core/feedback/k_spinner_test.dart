import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';

void main() {
  testWidgets('KSpinner renders a CircularProgressIndicator', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSpinner())),
    ));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('KSpinner respects custom size', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSpinner(size: 24))),
    ));
    await tester.pump();
    final box = tester.getSize(find.byType(KSpinner));
    expect(box.width, 24);
    expect(box.height, 24);
  });
}
