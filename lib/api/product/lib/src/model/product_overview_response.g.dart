// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_overview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductOverviewResponse extends ProductOverviewResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String name;
  @override
  final String imageUrl;
  @override
  final String status;
  @override
  final String baseUnitCode;
  @override
  final double sellPricePerUnit;
  @override
  final double currentStock;
  @override
  final double demandStock;
  @override
  final String category;
  @override
  final int variantCount;
  @override
  final String? brandId;
  @override
  final String? brandName;

  factory _$ProductOverviewResponse([
    void Function(ProductOverviewResponseBuilder)? updates,
  ]) => (ProductOverviewResponseBuilder()..update(updates))._build();

  _$ProductOverviewResponse._({
    required this.id,
    required this.orgId,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.baseUnitCode,
    required this.sellPricePerUnit,
    required this.currentStock,
    required this.demandStock,
    required this.category,
    required this.variantCount,
    this.brandId,
    this.brandName,
  }) : super._();
  @override
  ProductOverviewResponse rebuild(
    void Function(ProductOverviewResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductOverviewResponseBuilder toBuilder() =>
      ProductOverviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductOverviewResponse &&
        id == other.id &&
        orgId == other.orgId &&
        name == other.name &&
        imageUrl == other.imageUrl &&
        status == other.status &&
        baseUnitCode == other.baseUnitCode &&
        sellPricePerUnit == other.sellPricePerUnit &&
        currentStock == other.currentStock &&
        demandStock == other.demandStock &&
        category == other.category &&
        variantCount == other.variantCount &&
        brandId == other.brandId &&
        brandName == other.brandName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, baseUnitCode.hashCode);
    _$hash = $jc(_$hash, sellPricePerUnit.hashCode);
    _$hash = $jc(_$hash, currentStock.hashCode);
    _$hash = $jc(_$hash, demandStock.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, variantCount.hashCode);
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jc(_$hash, brandName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductOverviewResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('name', name)
          ..add('imageUrl', imageUrl)
          ..add('status', status)
          ..add('baseUnitCode', baseUnitCode)
          ..add('sellPricePerUnit', sellPricePerUnit)
          ..add('currentStock', currentStock)
          ..add('demandStock', demandStock)
          ..add('category', category)
          ..add('variantCount', variantCount)
          ..add('brandId', brandId)
          ..add('brandName', brandName))
        .toString();
  }
}

class ProductOverviewResponseBuilder
    implements
        Builder<ProductOverviewResponse, ProductOverviewResponseBuilder> {
  _$ProductOverviewResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _baseUnitCode;
  String? get baseUnitCode => _$this._baseUnitCode;
  set baseUnitCode(String? baseUnitCode) => _$this._baseUnitCode = baseUnitCode;

  double? _sellPricePerUnit;
  double? get sellPricePerUnit => _$this._sellPricePerUnit;
  set sellPricePerUnit(double? sellPricePerUnit) =>
      _$this._sellPricePerUnit = sellPricePerUnit;

  double? _currentStock;
  double? get currentStock => _$this._currentStock;
  set currentStock(double? currentStock) => _$this._currentStock = currentStock;

  double? _demandStock;
  double? get demandStock => _$this._demandStock;
  set demandStock(double? demandStock) => _$this._demandStock = demandStock;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _variantCount;
  int? get variantCount => _$this._variantCount;
  set variantCount(int? variantCount) => _$this._variantCount = variantCount;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  String? _brandName;
  String? get brandName => _$this._brandName;
  set brandName(String? brandName) => _$this._brandName = brandName;

  ProductOverviewResponseBuilder() {
    ProductOverviewResponse._defaults(this);
  }

  ProductOverviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _name = $v.name;
      _imageUrl = $v.imageUrl;
      _status = $v.status;
      _baseUnitCode = $v.baseUnitCode;
      _sellPricePerUnit = $v.sellPricePerUnit;
      _currentStock = $v.currentStock;
      _demandStock = $v.demandStock;
      _category = $v.category;
      _variantCount = $v.variantCount;
      _brandId = $v.brandId;
      _brandName = $v.brandName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductOverviewResponse other) {
    _$v = other as _$ProductOverviewResponse;
  }

  @override
  void update(void Function(ProductOverviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductOverviewResponse build() => _build();

  _$ProductOverviewResponse _build() {
    final _$result =
        _$v ??
        _$ProductOverviewResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ProductOverviewResponse',
            'id',
          ),
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'ProductOverviewResponse',
            'orgId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'ProductOverviewResponse',
            'name',
          ),
          imageUrl: BuiltValueNullFieldError.checkNotNull(
            imageUrl,
            r'ProductOverviewResponse',
            'imageUrl',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'ProductOverviewResponse',
            'status',
          ),
          baseUnitCode: BuiltValueNullFieldError.checkNotNull(
            baseUnitCode,
            r'ProductOverviewResponse',
            'baseUnitCode',
          ),
          sellPricePerUnit: BuiltValueNullFieldError.checkNotNull(
            sellPricePerUnit,
            r'ProductOverviewResponse',
            'sellPricePerUnit',
          ),
          currentStock: BuiltValueNullFieldError.checkNotNull(
            currentStock,
            r'ProductOverviewResponse',
            'currentStock',
          ),
          demandStock: BuiltValueNullFieldError.checkNotNull(
            demandStock,
            r'ProductOverviewResponse',
            'demandStock',
          ),
          category: BuiltValueNullFieldError.checkNotNull(
            category,
            r'ProductOverviewResponse',
            'category',
          ),
          variantCount: BuiltValueNullFieldError.checkNotNull(
            variantCount,
            r'ProductOverviewResponse',
            'variantCount',
          ),
          brandId: brandId,
          brandName: brandName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
