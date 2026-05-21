import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('KListRow renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      wrap(
        const KListRow(
          leading: Icon(Icons.bookmark),
          title: 'Coffee Co',
          subtitle: '15 products',
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Coffee Co'), findsOneWidget);
    expect(find.text('15 products'), findsOneWidget);
  });

  testWidgets('KListRow fires onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(
        KListRow(
          leading: const Icon(Icons.bookmark),
          title: 'Coffee Co',
          onTap: () => tapped++,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(KListRow));
    expect(tapped, 1);
  });

  testWidgets('KListRow renders trailing widget', (tester) async {
    await tester.pumpWidget(
      wrap(
        KListRow(
          leading: const Icon(Icons.bookmark),
          title: 'Coffee Co',
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
  });

  testWidgets('KListRow fires onLongPress', (tester) async {
    var lp = 0;
    await tester.pumpWidget(
      wrap(
        KListRow(
          leading: const Icon(Icons.bookmark),
          title: 'Coffee Co',
          onLongPress: () => lp++,
        ),
      ),
    );
    await tester.pump();
    await tester.longPress(find.byType(KListRow));
    expect(lp, 1);
  });
}
