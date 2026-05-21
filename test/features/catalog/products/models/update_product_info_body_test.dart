import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/json_optional.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';

void main() {
  test('only productId by default', () {
    const b = UpdateProductInfoBody(productId: 'p-1');
    expect(b.toJson(), {'productId': 'p-1'});
  });

  test('set name + sellPrice', () {
    const b = UpdateProductInfoBody(
      productId: 'p-1',
      name: 'X',
      sellPrice: 1000,
    );
    expect(b.toJson(), {'productId': 'p-1', 'name': 'X', 'sellPrice': 1000});
  });

  test('clear categoryId sends explicit null', () {
    const b = UpdateProductInfoBody(
      productId: 'p-1',
      categoryId: JsonOptional<String>.clear(),
    );
    expect(b.toJson(), {'productId': 'p-1', 'categoryId': null});
  });

  test('set categoryId sends the id', () {
    const b = UpdateProductInfoBody(
      productId: 'p-1',
      categoryId: JsonOptional.set('c-2'),
    );
    expect(b.toJson(), {'productId': 'p-1', 'categoryId': 'c-2'});
  });

  test('archive sets status ARCHIVED', () {
    const b = UpdateProductInfoBody(productId: 'p-1', status: 'ARCHIVED');
    expect(b.toJson()['status'], 'ARCHIVED');
  });
}
