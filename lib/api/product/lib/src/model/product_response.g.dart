// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductResponse extends ProductResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String? categoryId;
  @override
  final String? distributorId;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String name;
  @override
  final String status;
  @override
  final bool isDelete;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String baseUnitCode;
  @override
  final double sellPrice;
  @override
  final BuiltList<ProductUOMResponse>? umos;
  @override
  final BuiltList<ProductBarcodeResponse>? barcodes;
  @override
  final String? internalBarcode;
  @override
  final String? baseUnitLabel;
  @override
  final double? exportPrice;
  @override
  final String? containerLabel;
  @override
  final double? containerSize;
  @override
  final BuiltList<ProductStockResponse>? stocks;
  @override
  final double demandStock;
  @override
  final double? importPrice;
  @override
  final BuiltList<ProductVariantResponse>? variants;
  @override
  final double avgCost;
  @override
  final double totalCostValue;
  @override
  final double totalQtyImported;
  @override
  final String? brandId;
  @override
  final String? brandName;

  factory _$ProductResponse([void Function(ProductResponseBuilder)? updates]) =>
      (ProductResponseBuilder()..update(updates))._build();

  _$ProductResponse._({
    required this.id,
    required this.orgId,
    this.categoryId,
    this.distributorId,
    this.description,
    this.imageUrl,
    required this.name,
    required this.status,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.baseUnitCode,
    required this.sellPrice,
    this.umos,
    this.barcodes,
    this.internalBarcode,
    this.baseUnitLabel,
    this.exportPrice,
    this.containerLabel,
    this.containerSize,
    this.stocks,
    required this.demandStock,
    this.importPrice,
    this.variants,
    required this.avgCost,
    required this.totalCostValue,
    required this.totalQtyImported,
    this.brandId,
    this.brandName,
  }) : super._();
  @override
  ProductResponse rebuild(void Function(ProductResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductResponseBuilder toBuilder() => ProductResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductResponse &&
        id == other.id &&
        orgId == other.orgId &&
        categoryId == other.categoryId &&
        distributorId == other.distributorId &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        name == other.name &&
        status == other.status &&
        isDelete == other.isDelete &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        baseUnitCode == other.baseUnitCode &&
        sellPrice == other.sellPrice &&
        umos == other.umos &&
        barcodes == other.barcodes &&
        internalBarcode == other.internalBarcode &&
        baseUnitLabel == other.baseUnitLabel &&
        exportPrice == other.exportPrice &&
        containerLabel == other.containerLabel &&
        containerSize == other.containerSize &&
        stocks == other.stocks &&
        demandStock == other.demandStock &&
        importPrice == other.importPrice &&
        variants == other.variants &&
        avgCost == other.avgCost &&
        totalCostValue == other.totalCostValue &&
        totalQtyImported == other.totalQtyImported &&
        brandId == other.brandId &&
        brandName == other.brandName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, distributorId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, isDelete.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, baseUnitCode.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, umos.hashCode);
    _$hash = $jc(_$hash, barcodes.hashCode);
    _$hash = $jc(_$hash, internalBarcode.hashCode);
    _$hash = $jc(_$hash, baseUnitLabel.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, containerLabel.hashCode);
    _$hash = $jc(_$hash, containerSize.hashCode);
    _$hash = $jc(_$hash, stocks.hashCode);
    _$hash = $jc(_$hash, demandStock.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, avgCost.hashCode);
    _$hash = $jc(_$hash, totalCostValue.hashCode);
    _$hash = $jc(_$hash, totalQtyImported.hashCode);
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jc(_$hash, brandName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('categoryId', categoryId)
          ..add('distributorId', distributorId)
          ..add('description', description)
          ..add('imageUrl', imageUrl)
          ..add('name', name)
          ..add('status', status)
          ..add('isDelete', isDelete)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('baseUnitCode', baseUnitCode)
          ..add('sellPrice', sellPrice)
          ..add('umos', umos)
          ..add('barcodes', barcodes)
          ..add('internalBarcode', internalBarcode)
          ..add('baseUnitLabel', baseUnitLabel)
          ..add('exportPrice', exportPrice)
          ..add('containerLabel', containerLabel)
          ..add('containerSize', containerSize)
          ..add('stocks', stocks)
          ..add('demandStock', demandStock)
          ..add('importPrice', importPrice)
          ..add('variants', variants)
          ..add('avgCost', avgCost)
          ..add('totalCostValue', totalCostValue)
          ..add('totalQtyImported', totalQtyImported)
          ..add('brandId', brandId)
          ..add('brandName', brandName))
        .toString();
  }
}

class ProductResponseBuilder
    implements Builder<ProductResponse, ProductResponseBuilder> {
  _$ProductResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _distributorId;
  String? get distributorId => _$this._distributorId;
  set distributorId(String? distributorId) =>
      _$this._distributorId = distributorId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _isDelete;
  bool? get isDelete => _$this._isDelete;
  set isDelete(bool? isDelete) => _$this._isDelete = isDelete;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _baseUnitCode;
  String? get baseUnitCode => _$this._baseUnitCode;
  set baseUnitCode(String? baseUnitCode) => _$this._baseUnitCode = baseUnitCode;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  ListBuilder<ProductUOMResponse>? _umos;
  ListBuilder<ProductUOMResponse> get umos =>
      _$this._umos ??= ListBuilder<ProductUOMResponse>();
  set umos(ListBuilder<ProductUOMResponse>? umos) => _$this._umos = umos;

  ListBuilder<ProductBarcodeResponse>? _barcodes;
  ListBuilder<ProductBarcodeResponse> get barcodes =>
      _$this._barcodes ??= ListBuilder<ProductBarcodeResponse>();
  set barcodes(ListBuilder<ProductBarcodeResponse>? barcodes) =>
      _$this._barcodes = barcodes;

  String? _internalBarcode;
  String? get internalBarcode => _$this._internalBarcode;
  set internalBarcode(String? internalBarcode) =>
      _$this._internalBarcode = internalBarcode;

  String? _baseUnitLabel;
  String? get baseUnitLabel => _$this._baseUnitLabel;
  set baseUnitLabel(String? baseUnitLabel) =>
      _$this._baseUnitLabel = baseUnitLabel;

  double? _exportPrice;
  double? get exportPrice => _$this._exportPrice;
  set exportPrice(double? exportPrice) => _$this._exportPrice = exportPrice;

  String? _containerLabel;
  String? get containerLabel => _$this._containerLabel;
  set containerLabel(String? containerLabel) =>
      _$this._containerLabel = containerLabel;

  double? _containerSize;
  double? get containerSize => _$this._containerSize;
  set containerSize(double? containerSize) =>
      _$this._containerSize = containerSize;

  ListBuilder<ProductStockResponse>? _stocks;
  ListBuilder<ProductStockResponse> get stocks =>
      _$this._stocks ??= ListBuilder<ProductStockResponse>();
  set stocks(ListBuilder<ProductStockResponse>? stocks) =>
      _$this._stocks = stocks;

  double? _demandStock;
  double? get demandStock => _$this._demandStock;
  set demandStock(double? demandStock) => _$this._demandStock = demandStock;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  ListBuilder<ProductVariantResponse>? _variants;
  ListBuilder<ProductVariantResponse> get variants =>
      _$this._variants ??= ListBuilder<ProductVariantResponse>();
  set variants(ListBuilder<ProductVariantResponse>? variants) =>
      _$this._variants = variants;

  double? _avgCost;
  double? get avgCost => _$this._avgCost;
  set avgCost(double? avgCost) => _$this._avgCost = avgCost;

  double? _totalCostValue;
  double? get totalCostValue => _$this._totalCostValue;
  set totalCostValue(double? totalCostValue) =>
      _$this._totalCostValue = totalCostValue;

  double? _totalQtyImported;
  double? get totalQtyImported => _$this._totalQtyImported;
  set totalQtyImported(double? totalQtyImported) =>
      _$this._totalQtyImported = totalQtyImported;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  String? _brandName;
  String? get brandName => _$this._brandName;
  set brandName(String? brandName) => _$this._brandName = brandName;

  ProductResponseBuilder() {
    ProductResponse._defaults(this);
  }

  ProductResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _categoryId = $v.categoryId;
      _distributorId = $v.distributorId;
      _description = $v.description;
      _imageUrl = $v.imageUrl;
      _name = $v.name;
      _status = $v.status;
      _isDelete = $v.isDelete;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _baseUnitCode = $v.baseUnitCode;
      _sellPrice = $v.sellPrice;
      _umos = $v.umos?.toBuilder();
      _barcodes = $v.barcodes?.toBuilder();
      _internalBarcode = $v.internalBarcode;
      _baseUnitLabel = $v.baseUnitLabel;
      _exportPrice = $v.exportPrice;
      _containerLabel = $v.containerLabel;
      _containerSize = $v.containerSize;
      _stocks = $v.stocks?.toBuilder();
      _demandStock = $v.demandStock;
      _importPrice = $v.importPrice;
      _variants = $v.variants?.toBuilder();
      _avgCost = $v.avgCost;
      _totalCostValue = $v.totalCostValue;
      _totalQtyImported = $v.totalQtyImported;
      _brandId = $v.brandId;
      _brandName = $v.brandName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductResponse other) {
    _$v = other as _$ProductResponse;
  }

  @override
  void update(void Function(ProductResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductResponse build() => _build();

  _$ProductResponse _build() {
    _$ProductResponse _$result;
    try {
      _$result =
          _$v ??
          _$ProductResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ProductResponse',
              'id',
            ),
            orgId: BuiltValueNullFieldError.checkNotNull(
              orgId,
              r'ProductResponse',
              'orgId',
            ),
            categoryId: categoryId,
            distributorId: distributorId,
            description: description,
            imageUrl: imageUrl,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ProductResponse',
              'name',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'ProductResponse',
              'status',
            ),
            isDelete: BuiltValueNullFieldError.checkNotNull(
              isDelete,
              r'ProductResponse',
              'isDelete',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'ProductResponse',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'ProductResponse',
              'updatedAt',
            ),
            baseUnitCode: BuiltValueNullFieldError.checkNotNull(
              baseUnitCode,
              r'ProductResponse',
              'baseUnitCode',
            ),
            sellPrice: BuiltValueNullFieldError.checkNotNull(
              sellPrice,
              r'ProductResponse',
              'sellPrice',
            ),
            umos: _umos?.build(),
            barcodes: _barcodes?.build(),
            internalBarcode: internalBarcode,
            baseUnitLabel: baseUnitLabel,
            exportPrice: exportPrice,
            containerLabel: containerLabel,
            containerSize: containerSize,
            stocks: _stocks?.build(),
            demandStock: BuiltValueNullFieldError.checkNotNull(
              demandStock,
              r'ProductResponse',
              'demandStock',
            ),
            importPrice: importPrice,
            variants: _variants?.build(),
            avgCost: BuiltValueNullFieldError.checkNotNull(
              avgCost,
              r'ProductResponse',
              'avgCost',
            ),
            totalCostValue: BuiltValueNullFieldError.checkNotNull(
              totalCostValue,
              r'ProductResponse',
              'totalCostValue',
            ),
            totalQtyImported: BuiltValueNullFieldError.checkNotNull(
              totalQtyImported,
              r'ProductResponse',
              'totalQtyImported',
            ),
            brandId: brandId,
            brandName: brandName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'umos';
        _umos?.build();
        _$failedField = 'barcodes';
        _barcodes?.build();

        _$failedField = 'stocks';
        _stocks?.build();

        _$failedField = 'variants';
        _variants?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ProductResponse',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
