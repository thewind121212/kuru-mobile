// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductRequest extends CreateProductRequest {
  @override
  final String? categoryId;
  @override
  final String? distributorId;
  @override
  final String? brandId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? status;
  @override
  final String? baseUnitCode;
  @override
  final String? baseUnitLabel;
  @override
  final double sellPrice;
  @override
  final double? exportPrice;
  @override
  final String? containerLabel;
  @override
  final double? containerSize;
  @override
  final BuiltList<CreateProductPackRequest>? packs;
  @override
  final BuiltList<CreateProductBarcodeRequest>? barcodes;
  @override
  final BuiltList<CreateProductStockRequest>? initialStocks;
  @override
  final double demandStock;
  @override
  final double? importPrice;

  factory _$CreateProductRequest([
    void Function(CreateProductRequestBuilder)? updates,
  ]) => (CreateProductRequestBuilder()..update(updates))._build();

  _$CreateProductRequest._({
    this.categoryId,
    this.distributorId,
    this.brandId,
    required this.name,
    this.description,
    this.imageUrl,
    this.status,
    this.baseUnitCode,
    this.baseUnitLabel,
    required this.sellPrice,
    this.exportPrice,
    this.containerLabel,
    this.containerSize,
    this.packs,
    this.barcodes,
    this.initialStocks,
    required this.demandStock,
    this.importPrice,
  }) : super._();
  @override
  CreateProductRequest rebuild(
    void Function(CreateProductRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductRequestBuilder toBuilder() =>
      CreateProductRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductRequest &&
        categoryId == other.categoryId &&
        distributorId == other.distributorId &&
        brandId == other.brandId &&
        name == other.name &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        status == other.status &&
        baseUnitCode == other.baseUnitCode &&
        baseUnitLabel == other.baseUnitLabel &&
        sellPrice == other.sellPrice &&
        exportPrice == other.exportPrice &&
        containerLabel == other.containerLabel &&
        containerSize == other.containerSize &&
        packs == other.packs &&
        barcodes == other.barcodes &&
        initialStocks == other.initialStocks &&
        demandStock == other.demandStock &&
        importPrice == other.importPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, distributorId.hashCode);
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, baseUnitCode.hashCode);
    _$hash = $jc(_$hash, baseUnitLabel.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, containerLabel.hashCode);
    _$hash = $jc(_$hash, containerSize.hashCode);
    _$hash = $jc(_$hash, packs.hashCode);
    _$hash = $jc(_$hash, barcodes.hashCode);
    _$hash = $jc(_$hash, initialStocks.hashCode);
    _$hash = $jc(_$hash, demandStock.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductRequest')
          ..add('categoryId', categoryId)
          ..add('distributorId', distributorId)
          ..add('brandId', brandId)
          ..add('name', name)
          ..add('description', description)
          ..add('imageUrl', imageUrl)
          ..add('status', status)
          ..add('baseUnitCode', baseUnitCode)
          ..add('baseUnitLabel', baseUnitLabel)
          ..add('sellPrice', sellPrice)
          ..add('exportPrice', exportPrice)
          ..add('containerLabel', containerLabel)
          ..add('containerSize', containerSize)
          ..add('packs', packs)
          ..add('barcodes', barcodes)
          ..add('initialStocks', initialStocks)
          ..add('demandStock', demandStock)
          ..add('importPrice', importPrice))
        .toString();
  }
}

class CreateProductRequestBuilder
    implements Builder<CreateProductRequest, CreateProductRequestBuilder> {
  _$CreateProductRequest? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _distributorId;
  String? get distributorId => _$this._distributorId;
  set distributorId(String? distributorId) =>
      _$this._distributorId = distributorId;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _baseUnitCode;
  String? get baseUnitCode => _$this._baseUnitCode;
  set baseUnitCode(String? baseUnitCode) => _$this._baseUnitCode = baseUnitCode;

  String? _baseUnitLabel;
  String? get baseUnitLabel => _$this._baseUnitLabel;
  set baseUnitLabel(String? baseUnitLabel) =>
      _$this._baseUnitLabel = baseUnitLabel;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

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

  ListBuilder<CreateProductPackRequest>? _packs;
  ListBuilder<CreateProductPackRequest> get packs =>
      _$this._packs ??= ListBuilder<CreateProductPackRequest>();
  set packs(ListBuilder<CreateProductPackRequest>? packs) =>
      _$this._packs = packs;

  ListBuilder<CreateProductBarcodeRequest>? _barcodes;
  ListBuilder<CreateProductBarcodeRequest> get barcodes =>
      _$this._barcodes ??= ListBuilder<CreateProductBarcodeRequest>();
  set barcodes(ListBuilder<CreateProductBarcodeRequest>? barcodes) =>
      _$this._barcodes = barcodes;

  ListBuilder<CreateProductStockRequest>? _initialStocks;
  ListBuilder<CreateProductStockRequest> get initialStocks =>
      _$this._initialStocks ??= ListBuilder<CreateProductStockRequest>();
  set initialStocks(ListBuilder<CreateProductStockRequest>? initialStocks) =>
      _$this._initialStocks = initialStocks;

  double? _demandStock;
  double? get demandStock => _$this._demandStock;
  set demandStock(double? demandStock) => _$this._demandStock = demandStock;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  CreateProductRequestBuilder() {
    CreateProductRequest._defaults(this);
  }

  CreateProductRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _distributorId = $v.distributorId;
      _brandId = $v.brandId;
      _name = $v.name;
      _description = $v.description;
      _imageUrl = $v.imageUrl;
      _status = $v.status;
      _baseUnitCode = $v.baseUnitCode;
      _baseUnitLabel = $v.baseUnitLabel;
      _sellPrice = $v.sellPrice;
      _exportPrice = $v.exportPrice;
      _containerLabel = $v.containerLabel;
      _containerSize = $v.containerSize;
      _packs = $v.packs?.toBuilder();
      _barcodes = $v.barcodes?.toBuilder();
      _initialStocks = $v.initialStocks?.toBuilder();
      _demandStock = $v.demandStock;
      _importPrice = $v.importPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductRequest other) {
    _$v = other as _$CreateProductRequest;
  }

  @override
  void update(void Function(CreateProductRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductRequest build() => _build();

  _$CreateProductRequest _build() {
    _$CreateProductRequest _$result;
    try {
      _$result =
          _$v ??
          _$CreateProductRequest._(
            categoryId: categoryId,
            distributorId: distributorId,
            brandId: brandId,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CreateProductRequest',
              'name',
            ),
            description: description,
            imageUrl: imageUrl,
            status: status,
            baseUnitCode: baseUnitCode,
            baseUnitLabel: baseUnitLabel,
            sellPrice: BuiltValueNullFieldError.checkNotNull(
              sellPrice,
              r'CreateProductRequest',
              'sellPrice',
            ),
            exportPrice: exportPrice,
            containerLabel: containerLabel,
            containerSize: containerSize,
            packs: _packs?.build(),
            barcodes: _barcodes?.build(),
            initialStocks: _initialStocks?.build(),
            demandStock: BuiltValueNullFieldError.checkNotNull(
              demandStock,
              r'CreateProductRequest',
              'demandStock',
            ),
            importPrice: importPrice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'packs';
        _packs?.build();
        _$failedField = 'barcodes';
        _barcodes?.build();
        _$failedField = 'initialStocks';
        _initialStocks?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreateProductRequest',
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
