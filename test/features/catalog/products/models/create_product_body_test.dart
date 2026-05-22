import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';

void main() {
  test('toJson includes required fields, omits null optionals', () {
    const b = CreateProductBody(
      name: 'Cà phê',
      baseUnitCode: 'each',
      sellPrice: 25000,
    );
    expect(b.toJson(), {
      'name': 'Cà phê',
      'status': 'ACTIVE',
      'baseUnitCode': 'each',
      'sellPrice': 25000,
    });
  });

  test('toJson includes set optionals', () {
    const b = CreateProductBody(
      name: 'X',
      baseUnitCode: 'kg',
      sellPrice: 1000,
      categoryId: 'c-1',
      brandId: 'b-1',
      description: 'd',
    );
    final json = b.toJson();
    expect(json['categoryId'], 'c-1');
    expect(json['brandId'], 'b-1');
    expect(json['description'], 'd');
  });

  test('toJson includes initial branch stock', () {
    const b = CreateProductBody(
      name: 'X',
      baseUnitCode: 'each',
      sellPrice: 1000,
      initialStocks: [CreateProductStockBody(warehouseId: 'w-1', qty: 12)],
    );
    expect(b.toJson()['initialStocks'], [
      {'warehouseId': 'w-1', 'qty': 12},
    ]);
  });

  test('toJson includes variants', () {
    const b = CreateProductBody(
      name: 'X',
      baseUnitCode: 'each',
      sellPrice: 1000,
      variants: [
        CreateProductVariantBody(
          name: 'Size L',
          sellPrice: 30000,
          importPrice: 19000,
          exportPrice: 32000,
          attributeValueIds: ['av-1'],
        ),
      ],
    );
    expect(b.toJson()['variants'], [
      {
        'name': 'Size L',
        'sellPrice': 30000,
        'importPrice': 19000,
        'exportPrice': 32000,
        'attributeValueIds': ['av-1'],
      },
    ]);
  });
}
