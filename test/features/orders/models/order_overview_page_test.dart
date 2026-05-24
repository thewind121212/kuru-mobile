// test/features/orders/models/order_overview_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';

void main() {
  group('OrderOverviewPage', () {
    test('fromJson parses orders + pagination', () {
      final json = {
        'orders': [
          {
            'id': 'o_1',
            'orgId': 'org',
            'orderNumber': 'A-1',
            'status': 'PENDING',
            'paymentStatus': 'UNPAID',
            'totalAmount': 0,
            'paidAmount': 0,
            'itemCount': 0,
            'createdAt': '2026-05-23T08:00:00.000Z',
            'saleChannel': 'SHOP',
          },
        ],
        'total': 1,
        'page': 1,
        'limit': 20,
      };
      final p = OrderOverviewPage.fromJson(json);
      expect(p.orders.length, 1);
      expect(p.total, 1);
      expect(p.page, 1);
      expect(p.limit, 20);
    });

    test(
      'hasMore is true when orders.length == limit and total > page*limit',
      () {
        const p = OrderOverviewPage(orders: [], total: 100, page: 1, limit: 20);
        expect(p.hasMore, isTrue);
      },
    );

    test('hasMore is false at last page', () {
      const p = OrderOverviewPage(orders: [], total: 15, page: 1, limit: 20);
      expect(p.hasMore, isFalse);
    });
  });
}
