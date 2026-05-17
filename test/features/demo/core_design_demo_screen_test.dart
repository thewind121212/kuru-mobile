import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/demo/core_design_demo_screen.dart';

void main() {
  testWidgets(
    'CoreDesignDemoScreen renders every widget section',
    (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: const CoreDesignDemoScreen(),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Feedback'), findsOneWidget);
      expect(find.text('Input'), findsOneWidget);
      expect(find.text('Layout'), findsOneWidget);
      expect(find.text('Modal'), findsOneWidget);
      expect(find.text('Catalog'), findsOneWidget);
    },
  );
}
