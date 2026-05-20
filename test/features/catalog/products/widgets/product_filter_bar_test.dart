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

  testWidgets(
    'renders chip labels with "Tất cả" fallback when nothing picked',
    (t) async {
      await t.pumpWidget(
        wrap(
          ProductFilterBar(
            searchController: TextEditingController(),
            categoryLabel: null,
            brandLabel: null,
            onCategoryTap: () {},
            onBrandTap: () {},
          ),
        ),
      );
      expect(find.text('Danh mục: Tất cả'), findsOneWidget);
      expect(find.text('Thương hiệu: Tất cả'), findsOneWidget);
    },
  );

  testWidgets('uses selected names when present', (t) async {
    await t.pumpWidget(
      wrap(
        ProductFilterBar(
          searchController: TextEditingController(),
          categoryLabel: 'Đồ uống',
          brandLabel: 'A',
          onCategoryTap: () {},
          onBrandTap: () {},
        ),
      ),
    );
    expect(find.text('Danh mục: Đồ uống'), findsOneWidget);
    expect(find.text('Thương hiệu: A'), findsOneWidget);
  });
}
