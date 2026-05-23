// test/features/orders/models/order_line_item_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';

void main() {
  group('OrderLineItem.fromJson', () {
    test('parses a full BE response shape', () {
      final json = {
        'id': 'li_1',
        'orderId': 'o_1',
        'productId': 'p_1',
        'variantId': 'v_1',
        'productName': 'Coke 500ml',
        'variantName': 'Lime',
        'imageUrl': 'https://cdn/coke.jpg',
        'barcode': '8934567',
        'baseUnitCode': 'pcs',
        'qty': 2,
        'unitPrice': 12000,
        'discountType': 'PERCENTAGE',
        'discountValue': 10,
        'discountAmount': 2400,
        'totalAmount': 21600,
      };
      final line = OrderLineItem.fromJson(json);
      expect(line.id, 'li_1');
      expect(line.productName, 'Coke 500ml');
      expect(line.variantName, 'Lime');
      expect(line.qty, 2);
      expect(line.unitPrice, 12000);
      expect(line.discountType, DiscountType.percentage);
      expect(line.discountValue, 10);
      expect(line.discountAmount, 2400);
      expect(line.totalAmount, 21600);
    });

    test('parses minimal shape with nullable fields omitted', () {
      final json = {
        'productId': 'p_1',
        'productName': 'Bread',
        'baseUnitCode': 'pcs',
        'qty': 1,
        'unitPrice': 8000,
      };
      final line = OrderLineItem.fromJson(json);
      expect(line.id, isNull);
      expect(line.orderId, isNull);
      expect(line.variantId, isNull);
      expect(line.imageUrl, isNull);
      expect(line.discountType, isNull);
      expect(line.discountValue, isNull);
      expect(line.discountAmount, 0);
      expect(line.totalAmount, 0);
    });

    test('treats empty strings on imageUrl as null', () {
      final json = {
        'productId': 'p',
        'productName': 'n',
        'baseUnitCode': 'pcs',
        'qty': 1,
        'unitPrice': 1,
        'imageUrl': '',
      };
      expect(OrderLineItem.fromJson(json).imageUrl, isNull);
    });
  });
}
