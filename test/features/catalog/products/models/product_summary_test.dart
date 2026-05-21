import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';

void main() {
  group('ProductSummary.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'p-1',
        'name': 'Cà phê',
        'imageUrl': 'abc.jpg',
        'status': 'ACTIVE',
        'baseUnitCode': 'each',
        'sellPricePerUnit': 25000,
        'currentStock': 12,
        'demandStock': 5,
        'category': 'Đồ uống',
        'brandId': 'b-1',
        'brandName': 'Trung Nguyên',
        'variantCount': 1,
      };
      final p = ProductSummary.fromJson(json);
      expect(p.id, 'p-1');
      expect(p.name, 'Cà phê');
      expect(p.imageUrl, 'abc.jpg');
      expect(p.status, ProductStatus.active);
      expect(p.baseUnitCode, 'each');
      expect(p.sellPricePerUnit, 25000);
      expect(p.currentStock, 12);
      expect(p.demandStock, 5);
      expect(p.categoryName, 'Đồ uống');
      expect(p.brandId, 'b-1');
      expect(p.brandName, 'Trung Nguyên');
      expect(p.variantCount, 1);
    });

    test('empty-string imageUrl normalized to null', () {
      final p = ProductSummary.fromJson({
        'id': 'p-2',
        'name': 'X',
        'imageUrl': '',
        'status': 'INACTIVE',
        'baseUnitCode': 'kg',
        'sellPricePerUnit': 0,
        'currentStock': 0,
        'demandStock': 0,
        'category': '',
        'variantCount': 0,
      });
      expect(p.imageUrl, isNull);
      expect(p.categoryName, isNull);
      expect(p.brandId, isNull);
      expect(p.brandName, isNull);
    });
  });

  test('hasImage returns true only for non-empty URL', () {
    final withImg = ProductSummary.fromJson({
      'id': 'a',
      'name': 'a',
      'imageUrl': 'k.jpg',
      'status': 'ACTIVE',
      'baseUnitCode': 'each',
      'sellPricePerUnit': 1,
      'currentStock': 0,
      'demandStock': 0,
      'category': '',
      'variantCount': 0,
    });
    final without = ProductSummary.fromJson({
      'id': 'a',
      'name': 'a',
      'imageUrl': '',
      'status': 'ACTIVE',
      'baseUnitCode': 'each',
      'sellPricePerUnit': 1,
      'currentStock': 0,
      'demandStock': 0,
      'category': '',
      'variantCount': 0,
    });
    expect(withImg.hasImage, true);
    expect(without.hasImage, false);
  });
}
