import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';

part 'product_summary.freezed.dart';

@freezed
class ProductSummary with _$ProductSummary {
  const factory ProductSummary({
    required String id,
    required String name,
    required ProductStatus status,
    required String baseUnitCode,
    required num sellPricePerUnit,
    required num currentStock,
    required num demandStock,
    required int variantCount,
    String? imageUrl,
    String? categoryName,
    String? brandId,
    String? brandName,
  }) = _ProductSummary;

  const ProductSummary._();

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    final raw = json['imageUrl'] as String?;
    final cat = json['category'] as String?;
    return ProductSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: (raw == null || raw.isEmpty) ? null : raw,
      status: ProductStatus.fromWire(json['status'] as String?),
      baseUnitCode: json['baseUnitCode'] as String,
      sellPricePerUnit: (json['sellPricePerUnit'] as num?) ?? 0,
      currentStock: (json['currentStock'] as num?) ?? 0,
      demandStock: (json['demandStock'] as num?) ?? 0,
      categoryName: (cat == null || cat.isEmpty) ? null : cat,
      brandId: json['brandId'] as String?,
      brandName: json['brandName'] as String?,
      variantCount: (json['variantCount'] as int?) ?? 0,
    );
  }
}
