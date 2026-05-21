import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';

Widget wrap(Widget child) => MaterialApp(
  theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('AuthLogo', () {
    testWidgets('default renders both sparkle icons', (tester) async {
      await tester.pumpWidget(wrap(const AuthLogo()));
      // Avoid pumpAndSettle: AuthLogo has a continuously repeating glow.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.auto_awesome), findsNWidgets(2));
    });

    testWidgets('simple variant renders zero sparkle icons', (tester) async {
      await tester.pumpWidget(wrap(const AuthLogo(simple: true)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.auto_awesome), findsNothing);
    });

    testWidgets('simple variant still renders the logo image', (tester) async {
      await tester.pumpWidget(wrap(const AuthLogo(simple: true)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('disposes the animation controller cleanly when removed', (
      tester,
    ) async {
      // Mount, then replace — leaked tickers throw at test teardown.
      await tester.pumpWidget(wrap(const AuthLogo()));
      await tester.pump();
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();

      await tester.pumpWidget(wrap(const AuthLogo(simple: true)));
      await tester.pump();
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();
    });
  });
}
