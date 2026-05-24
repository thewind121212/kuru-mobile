// test/features/orders/models/order_summary_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/models/order_summary.dart';

void main() {
  group('OrderSummary.fromJson', () {
    test('parses full BE overview row', () {
      final json = {
        'id': 'o_1',
        'orgId': 'org_1',
        'orderNumber': 'A-1001',
        'status': 'PENDING',
        'paymentStatus': 'PARTIAL',
        'customerName': 'Anh Hai',
        'totalAmount': 120000,
        'paidAmount': 50000,
        'itemCount': 3,
        'createdAt': '2026-05-23T08:00:00.000Z',
        'saleChannel': 'SHOP',
        'storeId': 's_1',
        'storeName': 'Main',
      };
      final s = OrderSummary.fromJson(json);
      expect(s.orderNumber, 'A-1001');
      expect(s.status, OrderStatus.pending);
      expect(s.paymentStatus, OrderPaymentStatus.partial);
      expect(s.saleChannel, OrderSaleChannel.shop);
      expect(s.customerName, 'Anh Hai');
      expect(s.itemCount, 3);
    });

    test('handles missing customer + store', () {
      final json = {
        'id': 'o_1',
        'orgId': 'org_1',
        'orderNumber': 'A-1002',
        'status': 'DRAFT',
        'paymentStatus': 'UNPAID',
        'totalAmount': 0,
        'paidAmount': 0,
        'itemCount': 0,
        'createdAt': '2026-05-23T08:00:00.000Z',
        'saleChannel': 'SHOP',
      };
      final s = OrderSummary.fromJson(json);
      expect(s.customerName, isNull);
      expect(s.storeId, isNull);
      expect(s.storeName, isNull);
    });
  });
}
