import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';

part 'product_detail.freezed.dart';

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String id,
    required String name,
    required ProductStatus status,
    required String baseUnitCode,
    required num sellPrice,
    required num demandStock,
    required num avgCost,
    required num totalCostValue,
    required num totalQtyImported,
    String? imageUrl,
    String? baseUnitLabel,
    num? exportPrice,
    num? importPrice,
    String? categoryId,
    String? distributorId,
    String? brandId,
    String? brandName,
    String? description,
  }) = _ProductDetail;

  const ProductDetail._();

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final raw = json['imageUrl'] as String?;
    return ProductDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: (raw == null || raw.isEmpty) ? null : raw,
      status: ProductStatus.fromWire(json['status'] as String?),
      baseUnitCode: json['baseUnitCode'] as String,
      baseUnitLabel: json['baseUnitLabel'] as String?,
      sellPrice: (json['sellPrice'] as num?) ?? 0,
      exportPrice: json['exportPrice'] as num?,
      importPrice: json['importPrice'] as num?,
      categoryId: json['categoryId'] as String?,
      distributorId: json['distributorId'] as String?,
      brandId: json['brandId'] as String?,
      brandName: json['brandName'] as String?,
      description: json['description'] as String?,
      demandStock: (json['demandStock'] as num?) ?? 0,
      avgCost: (json['avgCost'] as num?) ?? 0,
      totalCostValue: (json['totalCostValue'] as num?) ?? 0,
      totalQtyImported: (json['totalQtyImported'] as num?) ?? 0,
    );
  }
}
