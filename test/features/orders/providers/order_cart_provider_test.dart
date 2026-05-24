import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

OrderLineItem _line({String pid = 'p', String? variantId, double qty = 1}) {
  return OrderLineItem(
    productId: pid,
    variantId: variantId,
    productName: 'P',
    baseUnitCode: 'pcs',
    qty: qty,
    unitPrice: 10000,
  );
}

void main() {
  test('OrderCart starts empty', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final draft = container.read(orderCartProvider);
    expect(draft.items, isEmpty);
    expect(draft.idempotencyKey, isNull);
  });

  test('addLine appends new line', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier).addLine(_line());
    expect(container.read(orderCartProvider).items.length, 1);
  });

  test('addLine merges qty when productId + variantId match', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..addLine(_line())
      ..addLine(_line(qty: 2));
    final items = container.read(orderCartProvider).items;
    expect(items.length, 1);
    expect(items.first.qty, 3);
  });

  test('addLine does not merge when variantId differs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..addLine(_line(variantId: 'v1'))
      ..addLine(_line(variantId: 'v2'));
    expect(container.read(orderCartProvider).items.length, 2);
  });

  test('ensureIdempotencyKey sets once, does not overwrite', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..ensureIdempotencyKey(() => 'first')
      ..ensureIdempotencyKey(() => 'second');
    expect(container.read(orderCartProvider).idempotencyKey, 'first');
  });

  test('mutating cart clears idempotencyKey', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..ensureIdempotencyKey(() => 'k')
      ..addLine(_line());
    expect(container.read(orderCartProvider).idempotencyKey, isNull);
  });

  test('setOrderDiscount stores type + value, clears key', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..ensureIdempotencyKey(() => 'k')
      ..setOrderDiscount(DiscountType.percentage, 10);
    final draft = container.read(orderCartProvider);
    expect(draft.discountType, DiscountType.percentage);
    expect(draft.discountValue, 10);
    expect(draft.idempotencyKey, isNull);
  });

  test('clear resets entire draft including key', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderCartProvider.notifier)
      ..addLine(_line())
      ..ensureIdempotencyKey(() => 'k')
      ..clear();
    final d = container.read(orderCartProvider);
    expect(d.items, isEmpty);
    expect(d.idempotencyKey, isNull);
  });
}
