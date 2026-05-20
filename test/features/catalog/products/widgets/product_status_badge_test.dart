import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_status_badge.dart';

void main() {
  Future<void> pump(WidgetTester t, ProductStatus s) => t.pumpWidget(
    MaterialApp(
      home: Scaffold(body: ProductStatusBadge(status: s)),
    ),
  );

  testWidgets('ACTIVE → "Đang bán"', (t) async {
    await pump(t, ProductStatus.active);
    expect(find.text('Đang bán'), findsOneWidget);
  });
  testWidgets('INACTIVE → "Tạm ngưng"', (t) async {
    await pump(t, ProductStatus.inactive);
    expect(find.text('Tạm ngưng'), findsOneWidget);
  });
  testWidgets('ARCHIVED → "Ngừng kinh doanh"', (t) async {
    await pump(t, ProductStatus.archived);
    expect(find.text('Ngừng kinh doanh'), findsOneWidget);
  });
}
