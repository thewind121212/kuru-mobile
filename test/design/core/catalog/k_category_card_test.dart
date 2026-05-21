import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/catalog/k_category_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('KCategoryCard renders name + stats', (tester) async {
    await tester.pumpWidget(
      wrap(
        const KCategoryCard(
          icon: Icons.coffee,
          iconBg: Colors.brown,
          name: 'Coffee',
          stats: [
            KCategoryCardStat(label: 'Items', value: '15'),
            KCategoryCardStat(label: 'Value', value: '₫1,200,000'),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Value'), findsOneWidget);
  });

  testWidgets('KCategoryCard fires onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(
        KCategoryCard(
          icon: Icons.coffee,
          iconBg: Colors.brown,
          name: 'Coffee',
          stats: const [KCategoryCardStat(label: 'Items', value: '15')],
          onTap: () => tapped++,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(KCategoryCard));
    expect(tapped, 1);
  });

  testWidgets('KCategoryCard renders lowStockBadge + trailingAction + menu', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const KCategoryCard(
          icon: Icons.coffee,
          iconBg: Colors.brown,
          name: 'Coffee',
          stats: [KCategoryCardStat(label: 'Items', value: '15')],
          lowStockBadge: Text('2 low stock'),
          trailingAction: Text('Filter products'),
          menu: Icon(Icons.more_vert),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('2 low stock'), findsOneWidget);
    expect(find.text('Filter products'), findsOneWidget);
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
  });
}
