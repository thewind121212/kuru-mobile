import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';

void main() {
  group('DiscountType', () {
    test('fromWire maps known values', () {
      expect(DiscountType.fromWire('PERCENTAGE'), DiscountType.percentage);
      expect(DiscountType.fromWire('FIXED'), DiscountType.fixed);
    });

    test('fromWire returns null for null input', () {
      expect(DiscountType.fromWire(null), isNull);
    });

    test('fromWire returns null for unknown values', () {
      expect(DiscountType.fromWire('FREE'), isNull);
      expect(DiscountType.fromWire(''), isNull);
    });

    test('toWire matches BE strings', () {
      expect(DiscountType.percentage.toWire(), 'PERCENTAGE');
      expect(DiscountType.fixed.toWire(), 'FIXED');
    });
  });
}
