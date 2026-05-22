import 'package:flutter/foundation.dart';

@immutable
class ProductStockLocation {
  const ProductStockLocation({
    required this.warehouseId,
    required this.qty,
    this.variantId,
  });

  final String warehouseId;
  final num qty;
  final String? variantId;

  factory ProductStockLocation.fromJson(Map<String, dynamic> json) {
    return ProductStockLocation(
      warehouseId: json['warehouseId'] as String? ?? '',
      qty: (json['qty'] as num?) ?? 0,
      variantId: json['variantId'] as String?,
    );
  }
}
