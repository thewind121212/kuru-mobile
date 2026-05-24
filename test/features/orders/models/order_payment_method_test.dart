import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';

void main() {
  group('OrderPaymentMethod', () {
    test('fromWire maps known values', () {
      expect(OrderPaymentMethod.fromWire('CASH'), OrderPaymentMethod.cash);
      expect(
        OrderPaymentMethod.fromWire('BANK_TRANSFER'),
        OrderPaymentMethod.bankTransfer,
      );
      expect(OrderPaymentMethod.fromWire('CARD'), OrderPaymentMethod.card);
      expect(OrderPaymentMethod.fromWire('OTHER'), OrderPaymentMethod.other);
    });

    test('fromWire defaults to other for unknown', () {
      expect(OrderPaymentMethod.fromWire('CRYPTO'), OrderPaymentMethod.other);
      expect(OrderPaymentMethod.fromWire(null), OrderPaymentMethod.other);
    });

    test('toWire matches BE strings', () {
      expect(OrderPaymentMethod.cash.toWire(), 'CASH');
      expect(OrderPaymentMethod.bankTransfer.toWire(), 'BANK_TRANSFER');
      expect(OrderPaymentMethod.card.toWire(), 'CARD');
      expect(OrderPaymentMethod.other.toWire(), 'OTHER');
    });
  });
}
