// test/features/orders/models/order_cart_draft_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';

void main() {
  group('OrderCartDraft', () {
    test('defaults', () {
      const d = OrderCartDraft();
      expect(d.items, isEmpty);
      expect(d.saleChannel, OrderSaleChannel.shop);
      expect(d.idempotencyKey, isNull);
    });
  });
}
