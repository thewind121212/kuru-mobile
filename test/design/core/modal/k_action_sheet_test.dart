import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('showKActionSheet renders all action labels', (tester) async {
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
      showKActionSheet<String>(
        context: capturedCtx,
        actions: const [
          KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
          KActionItem(
            id: 'delete',
            label: 'Delete',
            icon: Icons.delete,
            danger: true,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('showKActionSheet returns tapped id', (tester) async {
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

    final future = showKActionSheet<String>(
      context: capturedCtx,
      actions: const [
        KActionItem(id: 'edit', label: 'Edit'),
        KActionItem(id: 'delete', label: 'Delete', danger: true),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await future, 'delete');
  });

  testWidgets('showKActionSheet disabled action does not return its id', (
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

    final future = showKActionSheet<String>(
      context: capturedCtx,
      actions: const [
        KActionItem(id: 'edit', label: 'Edit'),
        KActionItem(id: 'delete', label: 'Delete', enabled: false),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pump();

    expect(find.text('Edit'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(await future, 'edit');
  });
}
