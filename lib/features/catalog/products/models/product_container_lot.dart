import 'package:flutter/foundation.dart';

@immutable
class ProductContainerLot {
  const ProductContainerLot({
    required this.id,
    required this.orgId,
    required this.warehouseId,
    required this.productId,
    required this.qtyInitial,
    required this.qtyRemaining,
    required this.createdAt,
    this.barcode,
    this.variantId,
    this.variantName,
  });

  final String id;
  final String orgId;
  final String warehouseId;
  final String productId;
  final num qtyInitial;
  final num qtyRemaining;
  final DateTime? createdAt;
  final String? barcode;
  final String? variantId;
  final String? variantName;

  bool get isEmpty => qtyRemaining <= 0;
  bool get isPartiallyUsed => qtyRemaining > 0 && qtyRemaining < qtyInitial;

  factory ProductContainerLot.fromJson(Map<String, dynamic> json) {
    final rawBarcode = json['barcode'] as String?;
    final rawVariantName = json['variantName'] as String?;
    return ProductContainerLot(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      warehouseId: json['warehouseId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      qtyInitial: (json['qtyInitial'] as num?) ?? 0,
      qtyRemaining: (json['qtyRemaining'] as num?) ?? 0,
      barcode: rawBarcode == null || rawBarcode.trim().isEmpty
          ? null
          : rawBarcode.trim(),
      variantId: json['variantId'] as String?,
      variantName: rawVariantName == null || rawVariantName.trim().isEmpty
          ? null
          : rawVariantName.trim(),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is String) return DateTime.tryParse(raw);
  if (raw is Map<String, dynamic>) {
    final seconds = raw['seconds'];
    final nanos = raw['nanos'];
    if (seconds is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        seconds.toInt() * 1000 + ((nanos is num) ? nanos ~/ 1000000 : 0),
        isUtc: true,
      );
    }
  }
  return null;
}
