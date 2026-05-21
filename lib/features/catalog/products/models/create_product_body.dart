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
    return m;
  }
}
