import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_filter_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('renders search field and zero count', (t) async {
    await t.pumpWidget(
      wrap(
        ProductFilterBar(
          searchController: TextEditingController(),
          activeCount: 0,
          activeChips: const [],
          onFilterTap: () {},
          onClearAll: () {},
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('0'), findsNothing); // 0 shouldn't display
  });

  testWidgets('renders active chips and clear button', (t) async {
    await t.pumpWidget(
      wrap(
        ProductFilterBar(
          searchController: TextEditingController(),
          activeCount: 2,
          activeChips: [
            ProductFilterChipData(label: 'Test Chip 1', onRemove: () {}),
            ProductFilterChipData(label: 'Test Chip 2', onRemove: () {}),
          ],
          onFilterTap: () {},
          onClearAll: () {},
        ),
      ),
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Test Chip 1'), findsOneWidget);
    expect(find.text('Test Chip 2'), findsOneWidget);
    expect(find.text('Xóa lọc'), findsOneWidget);
  });
}
