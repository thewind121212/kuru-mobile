import 'package:flutter/foundation.dart';

@immutable
class ProductUmo {
  const ProductUmo({
    required this.id,
    required this.label,
    required this.ratio,
    this.sellPrice,
    this.barcode,
  });

  final String id;
  final String label;
  final int ratio;
  final num? sellPrice;
  final String? barcode;

  factory ProductUmo.fromJson(Map<String, dynamic> json) {
    final barcodes = json['barcodes'] as List<dynamic>? ?? const [];
    String? barcode;
    for (final raw in barcodes) {
      final item = raw as Map<String, dynamic>;
      final value = item['value'] as String?;
      if (value != null && value.isNotEmpty) {
        barcode = value;
        break;
      }
    }
    return ProductUmo(
      id: json['id'] as String? ?? '',
      label: json['name'] as String? ?? json['label'] as String? ?? '',
      ratio: (json['ratio'] as num?)?.toInt() ?? 1,
      sellPrice: json['sellPrice'] as num?,
      barcode: barcode,
    );
  }
}
