import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('KPageHeader renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      wrap(const KPageHeader(title: 'Brands', subtitle: 'Manage your brands')),
    );
    await tester.pump();
    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Manage your brands'), findsOneWidget);
  });

  testWidgets('KPageHeader without subtitle renders only the title', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const KPageHeader(title: 'Brands')));
    await tester.pump();
    expect(find.text('Brands'), findsOneWidget);
  });

  testWidgets('KPageHeader renders trailing actions', (tester) async {
    await tester.pumpWidget(
      wrap(
        KPageHeader(
          title: 'Brands',
          actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
