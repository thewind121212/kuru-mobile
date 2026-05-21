import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('KSearchBar shows hint text', (tester) async {
    await tester.pumpWidget(
      wrap(KSearchBar(hint: 'Search brands', onChanged: (_) {})),
    );
    await tester.pump();
    expect(find.text('Search brands'), findsOneWidget);
  });

  testWidgets('KSearchBar fires onChanged on text entry', (tester) async {
    String? captured;
    await tester.pumpWidget(
      wrap(KSearchBar(hint: '', onChanged: (v) => captured = v)),
    );
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'cof');
    expect(captured, 'cof');
  });

  testWidgets('KSearchBar shows clear button when text is non-empty', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(KSearchBar(hint: '', onChanged: (_) {})));
    await tester.pump();

    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), 'cof');
    await tester.pump();
    expect(find.byTooltip('Clear'), findsOneWidget);
  });

  testWidgets('KSearchBar clear button empties text and fires onChanged("")', (
    tester,
  ) async {
    String? captured;
    await tester.pumpWidget(
      wrap(KSearchBar(hint: '', onChanged: (v) => captured = v)),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'cof');
    expect(captured, 'cof');

    await tester.tap(find.byTooltip('Clear'));
    await tester.pump();
    expect(captured, '');
  });
}
