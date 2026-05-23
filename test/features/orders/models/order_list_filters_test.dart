// test/features/orders/models/order_list_filters_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

void main() {
  group('OrderListFilters', () {
    test('default values', () {
      const f = OrderListFilters();
      expect(f.search, isNull);
      expect(f.status, isNull);
      expect(f.page, 1);
      expect(f.limit, 20);
    });

    test('copyWith preserves unchanged + updates target', () {
      const f = OrderListFilters(page: 3);
      final next = f.copyWith(status: OrderStatus.completed);
      expect(next.page, 3);
      expect(next.status, OrderStatus.completed);
    });

    test('isEmptyOfFilters distinguishes pristine vs filtered', () {
      const empty = OrderListFilters();
      const filtered = OrderListFilters(search: 'abc');
      expect(empty.isEmptyOfFilters, isTrue);
      expect(filtered.isEmptyOfFilters, isFalse);
    });
  });
}
