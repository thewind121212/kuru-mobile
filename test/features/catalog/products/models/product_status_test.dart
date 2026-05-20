import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';

void main() {
  group('ProductStatus.fromWire', () {
    test('ACTIVE → active', () {
      expect(ProductStatus.fromWire('ACTIVE'), ProductStatus.active);
    });
    test('INACTIVE → inactive', () {
      expect(ProductStatus.fromWire('INACTIVE'), ProductStatus.inactive);
    });
    test('ARCHIVED → archived', () {
      expect(ProductStatus.fromWire('ARCHIVED'), ProductStatus.archived);
    });
    test('null defaults to active', () {
      expect(ProductStatus.fromWire(null), ProductStatus.active);
    });
    test('unknown defaults to active', () {
      expect(ProductStatus.fromWire('NEW_THING'), ProductStatus.active);
    });
  });

  group('ProductStatus.wire', () {
    test('active → ACTIVE', () => expect(ProductStatus.active.wire, 'ACTIVE'));
    test(
      'inactive → INACTIVE',
      () => expect(ProductStatus.inactive.wire, 'INACTIVE'),
    );
    test(
      'archived → ARCHIVED',
      () => expect(ProductStatus.archived.wire, 'ARCHIVED'),
    );
  });
}
