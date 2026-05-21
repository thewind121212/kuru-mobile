import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('showKIconPicker initially renders all curated icons', (
    tester,
  ) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (ctx) {
            capturedCtx = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    unawaited(showKIconPicker(context: capturedCtx, selected: 'box'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('box'), findsOneWidget);
    expect(find.bySemanticsLabel('package'), findsOneWidget);
    expect(find.bySemanticsLabel('layout-grid'), findsOneWidget);
  });

  testWidgets('showKIconPicker search narrows to matching icons', (
    tester,
  ) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (ctx) {
            capturedCtx = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    unawaited(showKIconPicker(context: capturedCtx, selected: 'box'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'shop');
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('shopping-cart'), findsOneWidget);
    expect(find.bySemanticsLabel('shopping-bag'), findsOneWidget);
    expect(find.bySemanticsLabel('coffee'), findsNothing);
  });

  testWidgets('showKIconPicker returns tapped icon name', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (ctx) {
            capturedCtx = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    final future = showKIconPicker(context: capturedCtx, selected: 'box');
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('package'));
    await tester.pumpAndSettle();

    expect(await future, 'package');
  });

  test('curated icons exposed by mapping is non-empty', () {
    expect(kCuratedIcons.isNotEmpty, isTrue);
  });
}
