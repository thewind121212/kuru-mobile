import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('showKConfirmDialog renders title + subtitle', (tester) async {
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

    unawaited(
      showKConfirmDialog(
        context: capturedCtx,
        title: 'Delete brand?',
        subtitle: 'This will permanently remove the brand.',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Delete brand?'), findsOneWidget);
    expect(
      find.text('This will permanently remove the brand.'),
      findsOneWidget,
    );
  });

  testWidgets('showKConfirmDialog returns true on Confirm', (tester) async {
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

    final future = showKConfirmDialog(context: capturedCtx, title: 'Delete?');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(await future, isTrue);
  });

  testWidgets('showKConfirmDialog returns null on Cancel', (tester) async {
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

    final future = showKConfirmDialog(context: capturedCtx, title: 'Delete?');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await future, isNull);
  });

  testWidgets('showKConfirmDialog info tone renders dialog', (tester) async {
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

    unawaited(
      showKConfirmDialog(
        context: capturedCtx,
        title: 'Sign out?',
        tone: KConfirmDialogTone.info,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);
  });

  testWidgets('showKConfirmDialog with onConfirm shows spinner during await', (
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

    final completer = Completer<void>();
    final future = showKConfirmDialog(
      context: capturedCtx,
      title: 'Delete?',
      onConfirm: () => completer.future,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(await future, isTrue);
  });

  testWidgets('showKConfirmDialog onConfirm throws → resolves null', (
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

    final future = showKConfirmDialog(
      context: capturedCtx,
      title: 'Delete?',
      onConfirm: () async => throw Exception('boom'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 300));

    expect(await future, isNull);
  });
}
