import 'package:flutter/foundation.dart';

@immutable
class ProductVariantAttribute {
  const ProductVariantAttribute({
    required this.id,
    required this.name,
    required this.values,
  });

  final String id;
  final String name;
  final List<ProductVariantAttributeValue> values;

  factory ProductVariantAttribute.fromJson(Map<String, dynamic> json) {
    return ProductVariantAttribute(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      values: (json['values'] as List<dynamic>? ?? const [])
          .map(
            (value) => ProductVariantAttributeValue.fromJson(
              value as Map<String, dynamic>,
            ),
          )
          .where((value) => value.id.isNotEmpty && value.value.isNotEmpty)
          .toList(),
    );
  }
}

@immutable
class ProductVariantAttributeValue {
  const ProductVariantAttributeValue({
    required this.id,
    required this.attributeId,
    required this.value,
  });

  final String id;
  final String attributeId;
  final String value;

  factory ProductVariantAttributeValue.fromJson(Map<String, dynamic> json) {
    return ProductVariantAttributeValue(
      id: json['id'] as String? ?? '',
      attributeId: json['attributeId'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}
