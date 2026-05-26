import 'package:flutter/foundation.dart';

@immutable
class PurchaseDraftLine {
  const PurchaseDraftLine({
    required this.productId,
    required this.productName,
    required this.warehouseId,
    required this.qty,
    required this.unitCost,
    this.variantId,
    this.variantName,
  });

  final String productId;
  final String productName;
  final String warehouseId;
  final num qty;
  final int unitCost;
  final String? variantId;
  final String? variantName;

  int get lineTotal => (qty * unitCost).round();

  PurchaseDraftLine copyWith({String? warehouseId, num? qty, int? unitCost}) {
    return PurchaseDraftLine(
      productId: productId,
      productName: productName,
      warehouseId: warehouseId ?? this.warehouseId,
      qty: qty ?? this.qty,
      unitCost: unitCost ?? this.unitCost,
      variantId: variantId,
      variantName: variantName,
    );
  }

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      'productId': productId,
      if (variantId != null && variantId!.isNotEmpty) 'variantId': variantId,
      'warehouseId': warehouseId,
      'qtyInput': qty,
      'unitCostInput': unitCost,
    };
  }
}
