// test/features/orders/models/order_cart_totals_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_totals.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';

OrderLineItem line({
  required double qty,
  required double unitPrice,
  DiscountType? discountType,
  double? discountValue,
}) {
  return OrderLineItem(
    productId: 'p',
    productName: 'P',
    baseUnitCode: 'pcs',
    qty: qty,
    unitPrice: unitPrice,
    discountType: discountType,
    discountValue: discountValue,
  );
}

void main() {
  group('computeOrderCartTotals', () {
    test('empty cart -> all zeros', () {
      final t = computeOrderCartTotals(const OrderCartDraft());
      expect(t.subtotal, 0);
      expect(t.orderDiscountAmount, 0);
      expect(t.taxAmount, 0);
      expect(t.total, 0);
    });

    test('single line, no adjustments', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(items: [line(qty: 2, unitPrice: 10000)]),
      );
      expect(t.subtotal, 20000);
      expect(t.total, 20000);
    });

    test('line percentage discount applies before subtotal', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [
            line(
              qty: 2,
              unitPrice: 10000,
              discountType: DiscountType.percentage,
              discountValue: 10,
            ),
          ],
        ),
      );
      // 2*10000 = 20000; 10% off = 2000; line total = 18000
      expect(t.subtotal, 18000);
      expect(t.total, 18000);
    });

    test('line fixed discount caps at line base', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [
            line(
              qty: 1,
              unitPrice: 10000,
              discountType: DiscountType.fixed,
              discountValue: 99999,
            ),
          ],
        ),
      );
      // 1*10000 - min(99999, 10000) = 0
      expect(t.subtotal, 0);
      expect(t.total, 0);
    });

    test('order percentage discount applies after line discounts', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 100000)],
          discountType: DiscountType.percentage,
          discountValue: 10,
        ),
      );
      expect(t.subtotal, 100000);
      expect(t.orderDiscountAmount, 10000);
      expect(t.total, 90000);
    });

    test('order fixed discount caps at subtotal', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 10000)],
          discountType: DiscountType.fixed,
          discountValue: 99999,
        ),
      );
      expect(t.orderDiscountAmount, 10000);
      expect(t.total, 0);
    });

    test('tax applies on (subtotal - orderDiscount), not raw subtotal', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 100000)],
          discountType: DiscountType.fixed,
          discountValue: 50000,
          manualTaxPercent: 10,
        ),
      );
      // base = 100000 - 50000 = 50000; tax = 5000; total = 55000
      expect(t.taxAmount, 5000);
      expect(t.total, 55000);
    });

    test('tax percent above 100 is clamped to 100', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 1000)],
          manualTaxPercent: 200,
        ),
      );
      expect(t.taxAmount, 1000); // 100% of 1000
    });

    test('tax percent below 0 is clamped to 0', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 1000)],
          manualTaxPercent: -50,
        ),
      );
      expect(t.taxAmount, 0);
    });

    test('order discount percent above 100 caps at 100', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [line(qty: 1, unitPrice: 1000)],
          discountType: DiscountType.percentage,
          discountValue: 200,
        ),
      );
      expect(t.orderDiscountAmount, 1000);
      expect(t.total, 0);
    });

    test('line + order discount + tax all composed', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(
          items: [
            line(
              qty: 2,
              unitPrice: 100000,
              discountType: DiscountType.percentage,
              discountValue: 10,
            ),
            // line: 2*100000 = 200000, -10% = 180000
          ],
          discountType: DiscountType.fixed,
          discountValue: 30000,
          manualTaxPercent: 10,
        ),
      );
      expect(t.subtotal, 180000);
      expect(t.orderDiscountAmount, 30000);
      expect(t.taxAmount, 15000); // 10% of 150000
      expect(t.total, 165000);
    });

    test('totals never go negative', () {
      final t = computeOrderCartTotals(
        OrderCartDraft(items: [line(qty: 1, unitPrice: 0)]),
      );
      expect(t.total, 0);
    });
  });
}
