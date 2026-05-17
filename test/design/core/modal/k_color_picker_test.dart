import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKColorPicker renders all 26 swatches', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    unawaited(showKColorPicker(context: capturedCtx, selected: 'red-400'));
    await tester.pumpAndSettle();

    for (final c in kAllColors) {
      expect(
        find.bySemanticsLabel(c.label),
        findsOneWidget,
        reason: 'missing swatch ${c.label}',
      );
    }
  });

  testWidgets('showKColorPicker returns tapped id', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKColorPicker(
      context: capturedCtx,
      selected: 'red-400',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Blue'));
    await tester.pumpAndSettle();

    expect(await future, 'blue-400');
  });
}
