import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_container_lot.dart';

void main() {
  test('ProductContainerLot.fromJson parses full payload', () {
    final lot = ProductContainerLot.fromJson(const {
      'id': 'lot-1',
      'orgId': 'o-1',
      'warehouseId': 'w-1',
      'productId': 'p-1',
      'qtyInitial': 12,
      'qtyRemaining': 5,
      'barcode': ' LOT-001 ',
      'variantId': 'v-1',
      'variantName': 'Size L',
      'createdAt': '2026-05-20T10:30:00.000Z',
    });

    expect(lot.id, 'lot-1');
    expect(lot.orgId, 'o-1');
    expect(lot.warehouseId, 'w-1');
    expect(lot.productId, 'p-1');
    expect(lot.qtyInitial, 12);
    expect(lot.qtyRemaining, 5);
    expect(lot.barcode, 'LOT-001');
    expect(lot.variantId, 'v-1');
    expect(lot.variantName, 'Size L');
    expect(lot.createdAt, isNotNull);
    expect(lot.isPartiallyUsed, true);
    expect(lot.isEmpty, false);
  });

  test('ProductContainerLot.fromJson parses proto timestamp and blanks', () {
    final lot = ProductContainerLot.fromJson(const {
      'id': 'lot-2',
      'orgId': 'o-1',
      'warehouseId': 'w-1',
      'productId': 'p-1',
      'qtyInitial': 8,
      'qtyRemaining': 0,
      'barcode': ' ',
      'variantName': '',
      'createdAt': {'seconds': 1779282600, 'nanos': 500000000},
    });

    expect(lot.barcode, isNull);
    expect(lot.variantName, isNull);
    expect(
      lot.createdAt,
      DateTime.fromMillisecondsSinceEpoch(1779282600500, isUtc: true),
    );
    expect(lot.isEmpty, true);
  });
}
