import 'package:flutter/foundation.dart';

@immutable
class ProductBarcode {
  const ProductBarcode({
    required this.id,
    required this.value,
    required this.kind,
    this.productId,
    this.variantId,
    this.packId,
    this.isActive = true,
  });

  final String id;
  final String value;
  final String kind;
  final String? productId;
  final String? variantId;
  final String? packId;
  final bool isActive;

  bool get isAlias => kind.toUpperCase() == 'ALIAS';
  bool get isInternal => kind.toUpperCase() == 'INTERNAL';

  factory ProductBarcode.fromJson(Map<String, dynamic> json) {
    final rawValue = json['value'] as String? ?? '';
    return ProductBarcode(
      id: json['id'] as String? ?? '',
      value: rawValue.trim(),
      kind: json['kind'] as String? ?? '',
      productId: json['productId'] as String?,
      variantId: json['variantId'] as String?,
      packId: json['packId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
