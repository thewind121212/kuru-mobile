import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

part 'order_summary.freezed.dart';

@freezed
class OrderSummary with _$OrderSummary {
  const factory OrderSummary({
    required String id,
    required String orgId,
    required String orderNumber,
    required OrderStatus status,
    required OrderPaymentStatus paymentStatus,
    required double totalAmount,
    required double paidAmount,
    required int itemCount,
    required DateTime createdAt,
    required OrderSaleChannel saleChannel,
    String? customerName,
    String? storeId,
    String? storeName,
  }) = _OrderSummary;

  const OrderSummary._();

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      orderNumber: json['orderNumber'] as String,
      status: OrderStatus.fromWire(json['status'] as String?),
      paymentStatus: OrderPaymentStatus.fromWire(
        json['paymentStatus'] as String?,
      ),
      customerName: json['customerName'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      itemCount: (json['itemCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      saleChannel: OrderSaleChannel.fromWire(json['saleChannel'] as String?),
      storeId: json['storeId'] as String?,
      storeName: json['storeName'] as String?,
    );
  }
}
