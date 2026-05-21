import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('KSelect shows placeholder when value is null', (tester) async {
    await tester.pumpWidget(
      wrap(
        KSelect<String>(
          label: 'Status',
          value: null,
          placeholder: 'Choose status',
          options: const [
            KSelectOption(value: 'active', label: 'Active'),
            KSelectOption(value: 'inactive', label: 'Inactive'),
          ],
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Choose status'), findsOneWidget);
  });

  testWidgets('KSelect shows selected option label', (tester) async {
    await tester.pumpWidget(
      wrap(
        KSelect<String>(
          label: 'Status',
          value: 'active',
          options: const [
            KSelectOption(value: 'active', label: 'Active'),
            KSelectOption(value: 'inactive', label: 'Inactive'),
          ],
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('KSelect tapping opens action sheet with options', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        KSelect<String>(
          label: 'Status',
          value: null,
          options: const [
            KSelectOption(value: 'active', label: 'Active'),
            KSelectOption(value: 'inactive', label: 'Inactive'),
          ],
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(KSelect<String>));
    await tester.pumpAndSettle();

    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
  });

  testWidgets('KSelect picking an option fires onChanged', (tester) async {
    String? captured;
    await tester.pumpWidget(
      wrap(
        KSelect<String>(
          label: 'Status',
          value: null,
          options: const [
            KSelectOption(value: 'active', label: 'Active'),
            KSelectOption(value: 'inactive', label: 'Inactive'),
          ],
          onChanged: (v) => captured = v,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(KSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inactive'));
    await tester.pumpAndSettle();

    expect(captured, 'inactive');
  });
}
