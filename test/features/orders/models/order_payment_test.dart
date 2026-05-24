// test/features/orders/models/order_payment_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_payment.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';

void main() {
  group('OrderPayment.fromJson', () {
    test('parses full shape', () {
      final json = {
        'id': 'pm_1',
        'orderId': 'o_1',
        'method': 'CASH',
        'amount': 50000,
        'reference': 'R-001',
        'note': 'thanks',
        'paidAt': '2026-05-23T10:00:00.000Z',
      };
      final p = OrderPayment.fromJson(json);
      expect(p.id, 'pm_1');
      expect(p.method, OrderPaymentMethod.cash);
      expect(p.amount, 50000);
      expect(p.paidAt.toUtc().hour, 10);
    });

    test('omits optional fields', () {
      final json = {
        'id': 'pm_1',
        'orderId': 'o_1',
        'method': 'CARD',
        'amount': 10,
        'paidAt': '2026-05-23T10:00:00.000Z',
      };
      final p = OrderPayment.fromJson(json);
      expect(p.reference, isNull);
      expect(p.note, isNull);
    });
  });
}
