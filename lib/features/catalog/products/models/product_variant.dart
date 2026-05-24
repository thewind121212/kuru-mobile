import 'package:flutter/foundation.dart';

@immutable
class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.isDefault,
    required this.avgCost,
    required this.totalCostValue,
    required this.totalQtyImported,
    this.sellPrice,
    this.exportPrice,
    this.importPrice,
    this.barcode,
    this.imageUrl,
    this.attributes = const {},
    this.attributeValueIds = const [],
  });

  final String id;
  final String productId;
  final String name;
  final bool isDefault;
  final num? sellPrice;
  final num? exportPrice;
  final num? importPrice;
  final String? barcode;
  final String? imageUrl;
  final Map<String, String> attributes;
  final List<String> attributeValueIds;
  final num avgCost;
  final num totalCostValue;
  final num totalQtyImported;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final rawBarcode = json['barcode'] as String?;
    final rawImage = json['imageUrl'] as String?;
    return ProductVariant(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
      sellPrice: json['sellPrice'] as num?,
      exportPrice: json['exportPrice'] as num?,
      importPrice: json['importPrice'] as num?,
      barcode: rawBarcode == null || rawBarcode.isEmpty ? null : rawBarcode,
      imageUrl: rawImage == null || rawImage.isEmpty ? null : rawImage,
      attributes: (json['attributes'] as Map<String, dynamic>? ?? const {}).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      attributeValueIds:
          (json['attributeValueIds'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(),
      avgCost: (json['avgCost'] as num?) ?? 0,
      totalCostValue: (json['totalCostValue'] as num?) ?? 0,
      totalQtyImported: (json['totalQtyImported'] as num?) ?? 0,
    );
  }
}
