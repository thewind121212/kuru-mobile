import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_switch_row.dart';

void main() {
  testWidgets('toggles via callback', (tester) async {
    var value = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: KSwitchRow(
              leadingIcon: Icons.fingerprint,
              iconBackground: Colors.green.shade100,
              iconColor: Colors.green,
              label: 'FaceID',
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(value, isTrue);
  });
}
