import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';

void main() {
  group('OrderSaleChannel', () {
    test('fromWire maps known values', () {
      expect(OrderSaleChannel.fromWire('SHOP'), OrderSaleChannel.shop);
      expect(
        OrderSaleChannel.fromWire('ECOMMERCE'),
        OrderSaleChannel.ecommerce,
      );
    });

    test('fromWire defaults to shop for unknown', () {
      expect(OrderSaleChannel.fromWire('FOO'), OrderSaleChannel.shop);
      expect(OrderSaleChannel.fromWire(null), OrderSaleChannel.shop);
    });

    test('toWire matches BE strings', () {
      expect(OrderSaleChannel.shop.toWire(), 'SHOP');
      expect(OrderSaleChannel.ecommerce.toWire(), 'ECOMMERCE');
    });
  });
}
