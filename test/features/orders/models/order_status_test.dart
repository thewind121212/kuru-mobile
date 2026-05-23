import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

void main() {
  group('OrderStatus', () {
    test('fromWire maps all known values', () {
      expect(OrderStatus.fromWire('DRAFT'), OrderStatus.draft);
      expect(OrderStatus.fromWire('PENDING'), OrderStatus.pending);
      expect(OrderStatus.fromWire('COMPLETED'), OrderStatus.completed);
      expect(OrderStatus.fromWire('CANCELLED'), OrderStatus.cancelled);
    });

    test('fromWire defaults to draft for unknown', () {
      expect(OrderStatus.fromWire('FOO'), OrderStatus.draft);
      expect(OrderStatus.fromWire(null), OrderStatus.draft);
      expect(OrderStatus.fromWire(''), OrderStatus.draft);
    });

    test('toWire matches BE strings', () {
      expect(OrderStatus.draft.toWire(), 'DRAFT');
      expect(OrderStatus.pending.toWire(), 'PENDING');
      expect(OrderStatus.completed.toWire(), 'COMPLETED');
      expect(OrderStatus.cancelled.toWire(), 'CANCELLED');
    });
  });
}
