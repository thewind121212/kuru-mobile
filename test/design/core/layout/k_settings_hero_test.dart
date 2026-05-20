import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_hero.dart';

void main() {
  testWidgets('renders name + email + org chip', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(
          body: KSettingsHero(
            name: 'Linh Tran',
            email: 'linh@example.com',
            orgChip: 'Tiệm Linh · Chủ',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    expect(find.text('Linh Tran'), findsOneWidget);
    expect(find.text('linh@example.com'), findsOneWidget);
    expect(find.text('Tiệm Linh · Chủ'), findsOneWidget);
    await tester.tap(find.byType(KSettingsHero));
    expect(tapped, isTrue);
  });
}
