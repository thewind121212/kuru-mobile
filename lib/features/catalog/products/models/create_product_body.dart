class CreateProductBody {
  const CreateProductBody({
    required this.name,
    required this.baseUnitCode,
    required this.sellPrice,
    this.categoryId,
    this.brandId,
    this.description,
    this.importPrice,
    this.exportPrice,
    this.demandStock,
    this.initialStocks = const [],
    this.variants = const [],
    this.status = 'ACTIVE',
  });

  final String name;
  final String baseUnitCode;
  final num sellPrice;
  final String? categoryId;
  final String? brandId;
  final String? description;
  final num? importPrice;
  final num? exportPrice;
  final num? demandStock;
  final List<CreateProductStockBody> initialStocks;
  final List<CreateProductVariantBody> variants;
  final String status;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'name': name,
      'status': status,
      'baseUnitCode': baseUnitCode,
      'sellPrice': sellPrice,
    };
    if (categoryId != null) m['categoryId'] = categoryId;
    if (brandId != null) m['brandId'] = brandId;
    if (description != null) m['description'] = description;
    if (importPrice != null) m['importPrice'] = importPrice;
    if (exportPrice != null) m['exportPrice'] = exportPrice;
    if (demandStock != null) m['demandStock'] = demandStock;
    if (initialStocks.isNotEmpty) {
      m['initialStocks'] = initialStocks.map((s) => s.toJson()).toList();
    }
    if (variants.isNotEmpty) {
      m['variants'] = variants.map((v) => v.toJson()).toList();
    }
    return m;
  }
}

class CreateProductStockBody {
  const CreateProductStockBody({required this.warehouseId, required this.qty});

  final String warehouseId;
  final num qty;

  Map<String, dynamic> toJson() => {'warehouseId': warehouseId, 'qty': qty};
}

class CreateProductVariantBody {
  const CreateProductVariantBody({
    required this.name,
    this.sellPrice,
    this.importPrice,
    this.exportPrice,
    this.attributeValueIds = const [],
  });

  final String name;
  final num? sellPrice;
  final num? importPrice;
  final num? exportPrice;
  final List<String> attributeValueIds;

  Map<String, dynamic> toJson() => {
    'name': name,
    if (sellPrice != null) 'sellPrice': sellPrice,
    if (importPrice != null) 'importPrice': importPrice,
    if (exportPrice != null) 'exportPrice': exportPrice,
    if (attributeValueIds.isNotEmpty) 'attributeValueIds': attributeValueIds,
  };
}
