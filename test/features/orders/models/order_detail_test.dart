// test/features/orders/models/order_detail_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

void main() {
  group('OrderDetail.fromJson', () {
    test('parses a complete order with items + payments', () {
      final json = {
        'id': 'o_1',
        'orgId': 'org_1',
        'orderNumber': 'A-1001',
        'status': 'COMPLETED',
        'paymentStatus': 'PAID',
        'customerId': 'c_1',
        'customerName': 'Khách 1',
        'customerPhone': '0900',
        'note': 'rush',
        'subtotal': 100000,
        'discountType': 'PERCENTAGE',
        'discountValue': 10,
        'discountAmount': 10000,
        'taxAmount': 5000,
        'totalAmount': 95000,
        'paidAmount': 100000,
        'changeAmount': 5000,
        'storeId': 's_1',
        'storeName': 'Main',
        'createdAt': '2026-05-23T08:00:00.000Z',
        'updatedAt': '2026-05-23T08:30:00.000Z',
        'createdBy': 'u_1',
        'items': [
          {
            'id': 'li_1',
            'orderId': 'o_1',
            'productId': 'p_1',
            'productName': 'X',
            'baseUnitCode': 'pcs',
            'qty': 1,
            'unitPrice': 100000,
          },
        ],
        'payments': [
          {
            'id': 'pm_1',
            'orderId': 'o_1',
            'method': 'CASH',
            'amount': 100000,
            'paidAt': '2026-05-23T08:30:00.000Z',
          },
        ],
        'itemCount': 1,
        'saleChannel': 'SHOP',
      };
      final d = OrderDetail.fromJson(json);
      expect(d.orderNumber, 'A-1001');
      expect(d.status, OrderStatus.completed);
      expect(d.paymentStatus, OrderPaymentStatus.paid);
      expect(d.saleChannel, OrderSaleChannel.shop);
      expect(d.discountType, DiscountType.percentage);
      expect(d.items.length, 1);
      expect(d.payments.length, 1);
      expect(d.changeAmount, 5000);
    });

    test('defaults arrays + numbers when omitted', () {
      final json = {
        'id': 'o',
        'orgId': 'org',
        'orderNumber': 'A',
        'status': 'DRAFT',
        'paymentStatus': 'UNPAID',
        'subtotal': 0,
        'totalAmount': 0,
        'createdAt': '2026-05-23T08:00:00.000Z',
        'updatedAt': '2026-05-23T08:00:00.000Z',
        'createdBy': 'u',
        'itemCount': 0,
        'saleChannel': 'SHOP',
      };
      final d = OrderDetail.fromJson(json);
      expect(d.items, isEmpty);
      expect(d.payments, isEmpty);
      expect(d.discountAmount, 0);
      expect(d.taxAmount, 0);
      expect(d.paidAmount, 0);
      expect(d.changeAmount, 0);
    });
  });
}
