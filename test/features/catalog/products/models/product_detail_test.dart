import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';

void main() {
  test('ProductDetail.fromJson full payload', () {
    final json = {
      'id': 'p-1',
      'name': 'Cà phê',
      'imageUrl': 'k.jpg',
      'status': 'ACTIVE',
      'baseUnitCode': 'each',
      'baseUnitLabel': 'Cái',
      'sellPrice': 25000,
      'exportPrice': 30000,
      'importPrice': 18000,
      'categoryId': 'c-1',
      'distributorId': null,
      'brandId': 'b-1',
      'brandName': 'Trung Nguyên',
      'description': 'mô tả',
      'demandStock': 5,
      'avgCost': 17000,
      'totalCostValue': 204000,
      'totalQtyImported': 24,
      'stocks': [
        {'warehouseId': 'w-1', 'qty': 12},
      ],
      'umos': [
        {
          'id': 'u-1',
          'name': 'Thùng',
          'ratio': 24,
          'sellPrice': 240000,
          'barcodes': [
            {'value': 'box-1'},
          ],
        },
      ],
    };
    final p = ProductDetail.fromJson(json);
    expect(p.id, 'p-1');
    expect(p.name, 'Cà phê');
    expect(p.imageUrl, 'k.jpg');
    expect(p.hasImage, true);
    expect(p.status, ProductStatus.active);
    expect(p.baseUnitLabel, 'Cái');
    expect(p.sellPrice, 25000);
    expect(p.exportPrice, 30000);
    expect(p.importPrice, 18000);
    expect(p.categoryId, 'c-1');
    expect(p.distributorId, isNull);
    expect(p.brandId, 'b-1');
    expect(p.brandName, 'Trung Nguyên');
    expect(p.description, 'mô tả');
    expect(p.demandStock, 5);
    expect(p.avgCost, 17000);
    expect(p.totalCostValue, 204000);
    expect(p.totalQtyImported, 24);
    expect(p.stocks.single.warehouseId, 'w-1');
    expect(p.stocks.single.qty, 12);
    expect(p.umos.single.id, 'u-1');
    expect(p.umos.single.label, 'Thùng');
    expect(p.umos.single.ratio, 24);
    expect(p.umos.single.sellPrice, 240000);
    expect(p.umos.single.barcode, 'box-1');
  });

  test('ProductDetail.fromJson normalizes empty imageUrl to null', () {
    final p = ProductDetail.fromJson({
      'id': 'a',
      'name': 'a',
      'imageUrl': '',
      'status': 'ARCHIVED',
      'baseUnitCode': 'each',
      'sellPrice': 0,
      'demandStock': 0,
      'avgCost': 0,
      'totalCostValue': 0,
      'totalQtyImported': 0,
    });
    expect(p.imageUrl, isNull);
    expect(p.hasImage, false);
    expect(p.status, ProductStatus.archived);
  });
}
