import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('KEmptyState shows icon and title', (tester) async {
    await tester.pumpWidget(
      wrap(
        const KEmptyState(icon: Icons.inbox_outlined, title: 'No brands yet'),
      ),
    );
    await tester.pump();

    expect(find.text('No brands yet'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('KEmptyState shows subtitle when provided', (tester) async {
    await tester.pumpWidget(
      wrap(
        const KEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No brands yet',
          subtitle: 'Add your first brand to get started',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Add your first brand to get started'), findsOneWidget);
  });

  testWidgets('KEmptyState renders action when provided', (tester) async {
    await tester.pumpWidget(
      wrap(
        KEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No brands yet',
          action: ElevatedButton(
            onPressed: () {},
            child: const Text('Add brand'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Add brand'), findsOneWidget);
  });
}
