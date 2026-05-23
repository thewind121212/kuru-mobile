import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';

part 'order_line_item.freezed.dart';

@freezed
class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    required String productId,
    required String productName,
    required String baseUnitCode,
    required double qty,
    required double unitPrice,
    @Default(0) double discountAmount,
    @Default(0) double totalAmount,
    String? id,
    String? orderId,
    String? variantId,
    String? variantName,
    String? imageUrl,
    String? barcode,
    DiscountType? discountType,
    double? discountValue,
  }) = _OrderLineItem;

  const OrderLineItem._();

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    String? nullIfEmpty(Object? v) {
      final s = v as String?;
      return (s == null || s.isEmpty) ? null : s;
    }

    return OrderLineItem(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      productId: json['productId'] as String,
      variantId: json['variantId'] as String?,
      productName: json['productName'] as String,
      variantName: json['variantName'] as String?,
      imageUrl: nullIfEmpty(json['imageUrl']),
      barcode: json['barcode'] as String?,
      baseUnitCode: json['baseUnitCode'] as String,
      qty: (json['qty'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discountType: DiscountType.fromWire(json['discountType'] as String?),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}
