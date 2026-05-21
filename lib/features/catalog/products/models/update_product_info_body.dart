import 'package:kuru_mobile/core/network/json_optional.dart';

class UpdateProductInfoBody {
  const UpdateProductInfoBody({
    required this.productId,
    this.name,
    this.sellPrice,
    this.status,
    this.baseUnitCode,
    this.categoryId,
    this.brandId,
    this.distributorId,
    this.description,
    this.baseUnitLabel,
    this.exportPrice,
    this.importPrice,
    this.demandStock,
  });

  final String productId;
  final String? name;
  final num? sellPrice;
  final String? status;
  final String? baseUnitCode;
  final JsonOptional<String>? categoryId;
  final JsonOptional<String>? brandId;
  final JsonOptional<String>? distributorId;
  final JsonOptional<String>? description;
  final JsonOptional<String>? baseUnitLabel;
  final JsonOptional<num>? exportPrice;
  final JsonOptional<num>? importPrice;
  final JsonOptional<num>? demandStock;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{'productId': productId};
    if (name != null) m['name'] = name;
    if (sellPrice != null) m['sellPrice'] = sellPrice;
    if (status != null) m['status'] = status;
    if (baseUnitCode != null) m['baseUnitCode'] = baseUnitCode;
    JsonOptional.writeIfPresent(m, 'categoryId', categoryId);
    JsonOptional.writeIfPresent(m, 'brandId', brandId);
    JsonOptional.writeIfPresent(m, 'distributorId', distributorId);
    JsonOptional.writeIfPresent(m, 'description', description);
    JsonOptional.writeIfPresent(m, 'baseUnitLabel', baseUnitLabel);
    JsonOptional.writeIfPresent(m, 'exportPrice', exportPrice);
    JsonOptional.writeIfPresent(m, 'importPrice', importPrice);
    JsonOptional.writeIfPresent(m, 'demandStock', demandStock);
    return m;
  }
}
