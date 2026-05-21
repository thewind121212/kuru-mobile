import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_popup_menu.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  // Native context menus rely on platform channels — opening one is not
  // exercisable in a widget test. This smoke test asserts the wrapper
  // builds and the child shows up in the tree.
  testWidgets('KPopupMenu wraps child and renders it', (tester) async {
    await tester.pumpWidget(
      wrap(
        KPopupMenu<String>(
          actions: const [
            KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
            KActionItem(
              id: 'delete',
              label: 'Delete',
              icon: Icons.delete,
              danger: true,
            ),
          ],
          onSelected: (_) {},
          child: const Text('TARGET'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('TARGET'), findsOneWidget);
  });
}
