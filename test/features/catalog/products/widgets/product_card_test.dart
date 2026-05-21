import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_card.dart';

ProductSummary _ps({
  String name = 'Cà phê',
  num stock = 10,
  num demand = 5,
  String? imageUrl,
  String? cat = 'Đồ uống',
  String? brand = 'A',
}) => ProductSummary(
  id: 'p-1',
  name: name,
  imageUrl: imageUrl,
  status: ProductStatus.active,
  baseUnitCode: 'each',
  sellPricePerUnit: 25000,
  currentStock: stock,
  demandStock: demand,
  categoryName: cat,
  brandName: brand,
  variantCount: 1,
);

Widget _harness(Widget child) => MaterialApp(
  theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('renders compact name without category + brand subtitle', (
    t,
  ) async {
    await t.pumpWidget(_harness(ProductCard(product: _ps(), onTap: () {})));
    expect(find.text('Cà phê'), findsOneWidget);
    expect(find.text('Đồ uống · A'), findsNothing);
  });

  testWidgets('stock 0 → "Hết hàng"', (t) async {
    await t.pumpWidget(
      _harness(ProductCard(product: _ps(stock: 0), onTap: () {})),
    );
    expect(find.text('Hết hàng'), findsOneWidget);
  });

  testWidgets('renders stock progress with demand marker when demand set', (
    t,
  ) async {
    await t.pumpWidget(
      _harness(ProductCard(product: _ps(stock: 4, demand: 10), onTap: () {})),
    );

    expect(
      find.byKey(const ValueKey('product-card-stock-progress')),
      findsOneWidget,
    );
    expect(find.text('4 Cái'), findsOneWidget);
    expect(find.text('Cần 10'), findsOneWidget);
  });

  testWidgets('hides demand marker copy when demand is unset', (t) async {
    await t.pumpWidget(
      _harness(ProductCard(product: _ps(stock: 4, demand: 0), onTap: () {})),
    );

    expect(find.text('4 Cái'), findsOneWidget);
    expect(find.text('Cần 0'), findsNothing);
  });

  testWidgets('uses placeholder when imageUrl null', (t) async {
    await t.pumpWidget(_harness(ProductCard(product: _ps(), onTap: () {})));
    expect(
      find.byKey(const ValueKey('product-card-placeholder')),
      findsOneWidget,
    );
  });

  testWidgets('tap fires onTap', (t) async {
    var tapped = false;
    await t.pumpWidget(
      _harness(ProductCard(product: _ps(), onTap: () => tapped = true)),
    );
    await t.tap(find.byType(ProductCard));
    expect(tapped, true);
  });
}
