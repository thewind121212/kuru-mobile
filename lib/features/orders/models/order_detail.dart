import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_payment.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

part 'order_detail.freezed.dart';

@freezed
class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required String id,
    required String orgId,
    required String orderNumber,
    required OrderStatus status,
    required OrderPaymentStatus paymentStatus,
    required double subtotal,
    required double totalAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    required int itemCount,
    required OrderSaleChannel saleChannel,
    @Default(0) double discountAmount,
    @Default(0) double taxAmount,
    @Default(0) double paidAmount,
    @Default(0) double changeAmount,
    @Default(<OrderLineItem>[]) List<OrderLineItem> items,
    @Default(<OrderPayment>[]) List<OrderPayment> payments,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    String? taxRateId,
    String? storeId,
    String? storeName,
    DateTime? fulfilledAt,
    String? fulfilledBy,
  }) = _OrderDetail;

  const OrderDetail._();

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? v) =>
        v == null ? null : DateTime.parse(v as String);

    final items =
        (json['items'] as List<dynamic>?)
            ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <OrderLineItem>[];
    final payments =
        (json['payments'] as List<dynamic>?)
            ?.map((e) => OrderPayment.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <OrderPayment>[];

    return OrderDetail(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      orderNumber: json['orderNumber'] as String,
      status: OrderStatus.fromWire(json['status'] as String?),
      paymentStatus: OrderPaymentStatus.fromWire(
        json['paymentStatus'] as String?,
      ),
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      note: json['note'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discountType: DiscountType.fromWire(json['discountType'] as String?),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      taxRateId: json['taxRateId'] as String?,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      changeAmount: (json['changeAmount'] as num?)?.toDouble() ?? 0,
      storeId: json['storeId'] as String?,
      storeName: json['storeName'] as String?,
      fulfilledAt: parseDate(json['fulfilledAt']),
      fulfilledBy: json['fulfilledBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      items: items,
      payments: payments,
      itemCount: (json['itemCount'] as num).toInt(),
      saleChannel: OrderSaleChannel.fromWire(json['saleChannel'] as String?),
    );
  }
}
