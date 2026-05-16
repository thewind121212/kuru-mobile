import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets(
    'showKModalSheet opens and renders title + body',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      unawaited(showKModalSheet<void>(
        context: capturedCtx,
        title: 'Create brand',
        subtitle: 'Add a brand to your catalog',
        builder: (_) => const Text('BODY'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Create brand'), findsOneWidget);
      expect(find.text('Add a brand to your catalog'), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
    },
  );

  testWidgets(
    'showKModalSheet returns null when dismissed via X',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      final future = showKModalSheet<String>(
        context: capturedCtx,
        title: 'Test',
        builder: (_) => const Text('BODY'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Close'));
      await tester.pumpAndSettle();

      expect(await future, isNull);
    },
  );

  testWidgets(
    'showKModalSheet confirm with onConfirm=true closes sheet',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      final future = showKModalSheet<bool>(
        context: capturedCtx,
        title: 'Test',
        confirmLabel: 'Save',
        onConfirm: () async => true,
        builder: (_) => const Text('BODY'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      // Spinner state in frame during awaited onConfirm — use explicit
      // pump steps instead of pumpAndSettle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 300));

      expect(await future, isNotNull);
      expect(find.text('BODY'), findsNothing);
    },
  );

  testWidgets(
    'showKModalSheet onConfirm=false keeps the sheet open',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      unawaited(showKModalSheet<bool>(
        context: capturedCtx,
        title: 'Test',
        confirmLabel: 'Save',
        onConfirm: () async => false,
        builder: (_) => const Text('BODY'),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('BODY'), findsOneWidget);
    },
  );

  testWidgets(
    'showKModalSheet disableConfirm renders confirm but no tap',
    (tester) async {
      var confirmTapped = 0;
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      unawaited(showKModalSheet<bool>(
        context: capturedCtx,
        title: 'Test',
        confirmLabel: 'Save',
        disableConfirm: true,
        onConfirm: () async {
          confirmTapped++;
          return true;
        },
        builder: (_) => const Text('BODY'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(confirmTapped, 0);
      expect(find.text('BODY'), findsOneWidget);
    },
  );

  testWidgets(
    'showKModalSheet showCancel=false hides Cancel button',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      unawaited(showKModalSheet<void>(
        context: capturedCtx,
        title: 'Pick color',
        confirmLabel: 'Done',
        showCancel: false,
        onConfirm: () async => true,
        builder: (_) => const Text('GRID'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Cancel'), findsNothing);
    },
  );

  testWidgets(
    'showKModalSheet loadingBody replaces builder output',
    (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(wrap(Builder(builder: (ctx) {
        capturedCtx = ctx;
        return const SizedBox.shrink();
      })));
      await tester.pump();

      unawaited(showKModalSheet<void>(
        context: capturedCtx,
        title: 'Edit brand',
        loadingBody: const Center(child: Text('LOADING')),
        builder: (_) => const Text('FORM'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('LOADING'), findsOneWidget);
      expect(find.text('FORM'), findsNothing);
    },
  );
}
