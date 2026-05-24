import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/core/parsing/parse_date.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';

part 'order_payment.freezed.dart';

@freezed
class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String id,
    required String orderId,
    required OrderPaymentMethod method,
    required double amount,
    required DateTime paidAt,
    String? reference,
    String? note,
  }) = _OrderPayment;

  const OrderPayment._();

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      method: OrderPaymentMethod.fromWire(json['method'] as String?),
      amount: (json['amount'] as num).toDouble(),
      reference: json['reference'] as String?,
      note: json['note'] as String?,
      paidAt: parseProtoDateRequired(json['paidAt'], field: 'paidAt'),
    );
  }
}
