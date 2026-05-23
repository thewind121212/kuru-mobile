import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_totals.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

/// `/api/v1`-scoped dio (clone of shared, same pattern as productDioProvider).
final ordersDioProvider = Provider<Dio>((ref) {
  final shared = ref.watch(dioProvider);
  final d = Dio(shared.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'));
  wireSuperTokensToDio(d);
  d.interceptors.addAll(shared.interceptors);
  return d;
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(ordersDioProvider));
});

/// Mutable filter state. Page resets to 1 on filter change.
class OrderFiltersNotifier extends Notifier<OrderListFilters> {
  @override
  OrderListFilters build() => const OrderListFilters();

  void setSearch(String? s) => state = state.copyWith(search: s, page: 1);
  void setStatus(OrderStatus? s) => state = state.copyWith(status: s, page: 1);
  void setPaymentStatus(OrderPaymentStatus? s) =>
      state = state.copyWith(paymentStatus: s, page: 1);
  void setDateRange(DateTime? from, DateTime? to) =>
      state = state.copyWith(fromDate: from, toDate: to, page: 1);
  void setSaleChannel(OrderSaleChannel? c) =>
      state = state.copyWith(saleChannel: c, page: 1);
  void nextPage() => state = state.copyWith(page: state.page + 1);
  void reset() => state = const OrderListFilters();
}

final orderFiltersProvider =
    NotifierProvider<OrderFiltersNotifier, OrderListFilters>(
      OrderFiltersNotifier.new,
    );

/// Single-page fetch. Accumulator upgrade comes in Task 7.2.
final orderListProvider = FutureProvider<OrderOverviewPage>((ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  final filters = ref.watch(orderFiltersProvider);
  if (orgId == null) {
    throw StateError('No org selected');
  }
  return ref
      .watch(orderRepositoryProvider)
      .getOrderOverview(orgId: orgId, filters: filters)
      .unwrap();
});

/// Order detail family.
final orderDetailProvider = FutureProvider.family<OrderDetail, String>((
  ref,
  orderId,
) async {
  return ref.watch(orderRepositoryProvider).getOrderById(orderId).unwrap();
});

/// Mutable cart for /orders/new.
class OrderCartNotifier extends Notifier<OrderCartDraft> {
  @override
  OrderCartDraft build() => const OrderCartDraft();

  void _clearKeyOnMaterialChange() {
    if (state.idempotencyKey != null) {
      state = state.copyWith(idempotencyKey: null);
    }
  }

  void addLine(OrderLineItem item) {
    _clearKeyOnMaterialChange();
    final existing = state.items.indexWhere(
      (e) => e.productId == item.productId && e.variantId == item.variantId,
    );
    if (existing >= 0) {
      final merged = state.items[existing].copyWith(
        qty: state.items[existing].qty + item.qty,
      );
      final next = [...state.items];
      next[existing] = merged;
      state = state.copyWith(items: next);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void updateLineAt(int index, OrderLineItem item) {
    _clearKeyOnMaterialChange();
    final next = [...state.items];
    next[index] = item;
    state = state.copyWith(items: next);
  }

  void removeLineAt(int index) {
    _clearKeyOnMaterialChange();
    final next = [...state.items]..removeAt(index);
    state = state.copyWith(items: next);
  }

  void setCustomer({String? name, String? phone}) {
    _clearKeyOnMaterialChange();
    state = state.copyWith(customerName: name, customerPhone: phone);
  }

  void setNote(String? note) {
    _clearKeyOnMaterialChange();
    state = state.copyWith(note: note);
  }

  void setOrderDiscount(DiscountType? type, double? value) {
    _clearKeyOnMaterialChange();
    state = state.copyWith(discountType: type, discountValue: value);
  }

  void setManualTaxPercent(double? pct) {
    _clearKeyOnMaterialChange();
    state = state.copyWith(manualTaxPercent: pct);
  }

  void setSaleChannel(OrderSaleChannel c) {
    _clearKeyOnMaterialChange();
    state = state.copyWith(saleChannel: c);
  }

  void ensureIdempotencyKey(String Function() factory) {
    if (state.idempotencyKey == null) {
      state = state.copyWith(idempotencyKey: factory());
    }
  }

  void clear() => state = const OrderCartDraft();
}

final orderCartProvider = NotifierProvider<OrderCartNotifier, OrderCartDraft>(
  OrderCartNotifier.new,
);

final orderCartTotalsProvider = Provider<OrderCartTotals>((ref) {
  return computeOrderCartTotals(ref.watch(orderCartProvider));
});
