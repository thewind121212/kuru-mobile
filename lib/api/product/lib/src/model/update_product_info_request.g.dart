// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_info_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductInfoRequest extends UpdateProductInfoRequest {
  @override
  final String productId;
  @override
  final String? name;
  @override
  final double? sellPrice;
  @override
  final String? categoryId;
  @override
  final String? distributorId;
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
  final double? exportPrice;
  @override
  final String? containerLabel;
  @override
  final double? containerSize;
  @override
  final double? demandStock;
  @override
  final double? importPrice;
  @override
  final String? brandId;

  factory _$UpdateProductInfoRequest([
    void Function(UpdateProductInfoRequestBuilder)? updates,
  ]) => (UpdateProductInfoRequestBuilder()..update(updates))._build();

  _$UpdateProductInfoRequest._({
    required this.productId,
    this.name,
    this.sellPrice,
    this.categoryId,
    this.distributorId,
    this.description,
    this.imageUrl,
    this.status,
    this.baseUnitCode,
    this.baseUnitLabel,
    this.exportPrice,
    this.containerLabel,
    this.containerSize,
    this.demandStock,
    this.importPrice,
    this.brandId,
  }) : super._();
  @override
  UpdateProductInfoRequest rebuild(
    void Function(UpdateProductInfoRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductInfoRequestBuilder toBuilder() =>
      UpdateProductInfoRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductInfoRequest &&
        productId == other.productId &&
        name == other.name &&
        sellPrice == other.sellPrice &&
        categoryId == other.categoryId &&
        distributorId == other.distributorId &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        status == other.status &&
        baseUnitCode == other.baseUnitCode &&
        baseUnitLabel == other.baseUnitLabel &&
        exportPrice == other.exportPrice &&
        containerLabel == other.containerLabel &&
        containerSize == other.containerSize &&
        demandStock == other.demandStock &&
        importPrice == other.importPrice &&
        brandId == other.brandId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, distributorId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, baseUnitCode.hashCode);
    _$hash = $jc(_$hash, baseUnitLabel.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, containerLabel.hashCode);
    _$hash = $jc(_$hash, containerSize.hashCode);
    _$hash = $jc(_$hash, demandStock.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateProductInfoRequest')
          ..add('productId', productId)
          ..add('name', name)
          ..add('sellPrice', sellPrice)
          ..add('categoryId', categoryId)
          ..add('distributorId', distributorId)
          ..add('description', description)
          ..add('imageUrl', imageUrl)
          ..add('status', status)
          ..add('baseUnitCode', baseUnitCode)
          ..add('baseUnitLabel', baseUnitLabel)
          ..add('exportPrice', exportPrice)
          ..add('containerLabel', containerLabel)
          ..add('containerSize', containerSize)
          ..add('demandStock', demandStock)
          ..add('importPrice', importPrice)
          ..add('brandId', brandId))
        .toString();
  }
}

class UpdateProductInfoRequestBuilder
    implements
        Builder<UpdateProductInfoRequest, UpdateProductInfoRequestBuilder> {
  _$UpdateProductInfoRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

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

  double? _demandStock;
  double? get demandStock => _$this._demandStock;
  set demandStock(double? demandStock) => _$this._demandStock = demandStock;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  UpdateProductInfoRequestBuilder() {
    UpdateProductInfoRequest._defaults(this);
  }

  UpdateProductInfoRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _name = $v.name;
      _sellPrice = $v.sellPrice;
      _categoryId = $v.categoryId;
      _distributorId = $v.distributorId;
      _description = $v.description;
      _imageUrl = $v.imageUrl;
      _status = $v.status;
      _baseUnitCode = $v.baseUnitCode;
      _baseUnitLabel = $v.baseUnitLabel;
      _exportPrice = $v.exportPrice;
      _containerLabel = $v.containerLabel;
      _containerSize = $v.containerSize;
      _demandStock = $v.demandStock;
      _importPrice = $v.importPrice;
      _brandId = $v.brandId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductInfoRequest other) {
    _$v = other as _$UpdateProductInfoRequest;
  }

  @override
  void update(void Function(UpdateProductInfoRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductInfoRequest build() => _build();

  _$UpdateProductInfoRequest _build() {
    final _$result =
        _$v ??
        _$UpdateProductInfoRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'UpdateProductInfoRequest',
            'productId',
          ),
          name: name,
          sellPrice: sellPrice,
          categoryId: categoryId,
          distributorId: distributorId,
          description: description,
          imageUrl: imageUrl,
          status: status,
          baseUnitCode: baseUnitCode,
          baseUnitLabel: baseUnitLabel,
          exportPrice: exportPrice,
          containerLabel: containerLabel,
          containerSize: containerSize,
          demandStock: demandStock,
          importPrice: importPrice,
          brandId: brandId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
