import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';

void main() {
  group('OrderPaymentStatus', () {
    test('fromWire maps known values', () {
      expect(OrderPaymentStatus.fromWire('UNPAID'), OrderPaymentStatus.unpaid);
      expect(
        OrderPaymentStatus.fromWire('PARTIAL'),
        OrderPaymentStatus.partial,
      );
      expect(OrderPaymentStatus.fromWire('PAID'), OrderPaymentStatus.paid);
    });

    test('fromWire defaults to unpaid for unknown', () {
      expect(OrderPaymentStatus.fromWire('FOO'), OrderPaymentStatus.unpaid);
      expect(OrderPaymentStatus.fromWire(null), OrderPaymentStatus.unpaid);
    });

    test('toWire matches BE strings', () {
      expect(OrderPaymentStatus.unpaid.toWire(), 'UNPAID');
      expect(OrderPaymentStatus.partial.toWire(), 'PARTIAL');
      expect(OrderPaymentStatus.paid.toWire(), 'PAID');
    });
  });
}
