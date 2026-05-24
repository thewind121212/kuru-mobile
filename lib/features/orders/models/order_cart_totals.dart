// lib/features/orders/models/order_cart_totals.dart
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';

part 'order_cart_totals.freezed.dart';

@freezed
class OrderCartTotals with _$OrderCartTotals {
  const factory OrderCartTotals({
    required double subtotal,
    required double orderDiscountAmount,
    required double taxAmount,
    required double total,
  }) = _OrderCartTotals;
}

double _lineDiscountAmount(OrderLineItem item) {
  final base = item.qty * item.unitPrice;
  if (item.discountType == null || item.discountValue == null) return 0;
  switch (item.discountType!) {
    case DiscountType.percentage:
      final pct = item.discountValue!.clamp(0, 100);
      return base * pct / 100;
    case DiscountType.fixed:
      return math.min(item.discountValue!, base).clamp(0, base);
  }
}

double _lineTotal(OrderLineItem item) {
  final base = item.qty * item.unitPrice;
  return math.max(0, base - _lineDiscountAmount(item));
}

OrderCartTotals computeOrderCartTotals(OrderCartDraft draft) {
  final subtotal = draft.items.fold<double>(0, (s, it) => s + _lineTotal(it));

  double orderDiscount = 0;
  if (draft.discountType != null && draft.discountValue != null) {
    switch (draft.discountType!) {
      case DiscountType.percentage:
        final pct = draft.discountValue!.clamp(0, 100);
        orderDiscount = subtotal * pct / 100;
      case DiscountType.fixed:
        orderDiscount = math.min(draft.discountValue!, subtotal);
    }
  }

  final afterDiscount = math.max<double>(0, subtotal - orderDiscount);

  double tax = 0;
  if (draft.manualTaxPercent != null) {
    final pct = draft.manualTaxPercent!.clamp(0, 100);
    tax = afterDiscount * pct / 100;
  }

  final total = math.max<double>(0, afterDiscount + tax);

  return OrderCartTotals(
    subtotal: subtotal,
    orderDiscountAmount: orderDiscount,
    taxAmount: tax,
    total: total,
  );
}
