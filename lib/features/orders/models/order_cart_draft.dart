import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';

part 'order_cart_draft.freezed.dart';

@freezed
class OrderCartDraft with _$OrderCartDraft {
  const factory OrderCartDraft({
    @Default(<OrderLineItem>[]) List<OrderLineItem> items,
    @Default(OrderSaleChannel.shop) OrderSaleChannel saleChannel,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    double? manualTaxPercent,
    String? idempotencyKey,
  }) = _OrderCartDraft;

  const OrderCartDraft._();

  bool get isEmpty => items.isEmpty;
}
