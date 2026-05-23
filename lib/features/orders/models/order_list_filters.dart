import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

part 'order_list_filters.freezed.dart';

@freezed
class OrderListFilters with _$OrderListFilters {
  const factory OrderListFilters({
    @Default(1) int page,
    @Default(20) int limit,
    String? search,
    OrderStatus? status,
    OrderPaymentStatus? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    OrderSaleChannel? saleChannel,
  }) = _OrderListFilters;

  const OrderListFilters._();

  bool get isEmptyOfFilters =>
      (search == null || search!.isEmpty) &&
      status == null &&
      paymentStatus == null &&
      fromDate == null &&
      toDate == null &&
      saleChannel == null;
}
