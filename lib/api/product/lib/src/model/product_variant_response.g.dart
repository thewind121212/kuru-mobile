// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductVariantResponse extends ProductVariantResponse {
  @override
  final String id;
  @override
  final String productId;
  @override
  final String name;
  @override
  final bool isDefault;
  @override
  final double? sellPrice;
  @override
  final double? exportPrice;
  @override
  final double? importPrice;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final BuiltMap<String, String> attributes;
  @override
  final String? barcode;
  @override
  final String? imageUrl;
  @override
  final BuiltList<String>? attributeValueIds;
  @override
  final double avgCost;
  @override
  final double totalCostValue;
  @override
  final double totalQtyImported;

  factory _$ProductVariantResponse([
    void Function(ProductVariantResponseBuilder)? updates,
  ]) => (ProductVariantResponseBuilder()..update(updates))._build();

  _$ProductVariantResponse._({
    required this.id,
    required this.productId,
    required this.name,
    required this.isDefault,
    this.sellPrice,
    this.exportPrice,
    this.importPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.attributes,
    this.barcode,
    this.imageUrl,
    this.attributeValueIds,
    required this.avgCost,
    required this.totalCostValue,
    required this.totalQtyImported,
  }) : super._();
  @override
  ProductVariantResponse rebuild(
    void Function(ProductVariantResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductVariantResponseBuilder toBuilder() =>
      ProductVariantResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductVariantResponse &&
        id == other.id &&
        productId == other.productId &&
        name == other.name &&
        isDefault == other.isDefault &&
        sellPrice == other.sellPrice &&
        exportPrice == other.exportPrice &&
        importPrice == other.importPrice &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        attributes == other.attributes &&
        barcode == other.barcode &&
        imageUrl == other.imageUrl &&
        attributeValueIds == other.attributeValueIds &&
        avgCost == other.avgCost &&
        totalCostValue == other.totalCostValue &&
        totalQtyImported == other.totalQtyImported;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, attributeValueIds.hashCode);
    _$hash = $jc(_$hash, avgCost.hashCode);
    _$hash = $jc(_$hash, totalCostValue.hashCode);
    _$hash = $jc(_$hash, totalQtyImported.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductVariantResponse')
          ..add('id', id)
          ..add('productId', productId)
          ..add('name', name)
          ..add('isDefault', isDefault)
          ..add('sellPrice', sellPrice)
          ..add('exportPrice', exportPrice)
          ..add('importPrice', importPrice)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('attributes', attributes)
          ..add('barcode', barcode)
          ..add('imageUrl', imageUrl)
          ..add('attributeValueIds', attributeValueIds)
          ..add('avgCost', avgCost)
          ..add('totalCostValue', totalCostValue)
          ..add('totalQtyImported', totalQtyImported))
        .toString();
  }
}

class ProductVariantResponseBuilder
    implements Builder<ProductVariantResponse, ProductVariantResponseBuilder> {
  _$ProductVariantResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  double? _exportPrice;
  double? get exportPrice => _$this._exportPrice;
  set exportPrice(double? exportPrice) => _$this._exportPrice = exportPrice;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  MapBuilder<String, String>? _attributes;
  MapBuilder<String, String> get attributes =>
      _$this._attributes ??= MapBuilder<String, String>();
  set attributes(MapBuilder<String, String>? attributes) =>
      _$this._attributes = attributes;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  ListBuilder<String>? _attributeValueIds;
  ListBuilder<String> get attributeValueIds =>
      _$this._attributeValueIds ??= ListBuilder<String>();
  set attributeValueIds(ListBuilder<String>? attributeValueIds) =>
      _$this._attributeValueIds = attributeValueIds;

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

  ProductVariantResponseBuilder() {
    ProductVariantResponse._defaults(this);
  }

  ProductVariantResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _productId = $v.productId;
      _name = $v.name;
      _isDefault = $v.isDefault;
      _sellPrice = $v.sellPrice;
      _exportPrice = $v.exportPrice;
      _importPrice = $v.importPrice;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _attributes = $v.attributes.toBuilder();
      _barcode = $v.barcode;
      _imageUrl = $v.imageUrl;
      _attributeValueIds = $v.attributeValueIds?.toBuilder();
      _avgCost = $v.avgCost;
      _totalCostValue = $v.totalCostValue;
      _totalQtyImported = $v.totalQtyImported;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductVariantResponse other) {
    _$v = other as _$ProductVariantResponse;
  }

  @override
  void update(void Function(ProductVariantResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductVariantResponse build() => _build();

  _$ProductVariantResponse _build() {
    _$ProductVariantResponse _$result;
    try {
      _$result =
          _$v ??
          _$ProductVariantResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ProductVariantResponse',
              'id',
            ),
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'ProductVariantResponse',
              'productId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ProductVariantResponse',
              'name',
            ),
            isDefault: BuiltValueNullFieldError.checkNotNull(
              isDefault,
              r'ProductVariantResponse',
              'isDefault',
            ),
            sellPrice: sellPrice,
            exportPrice: exportPrice,
            importPrice: importPrice,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'ProductVariantResponse',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'ProductVariantResponse',
              'updatedAt',
            ),
            attributes: attributes.build(),
            barcode: barcode,
            imageUrl: imageUrl,
            attributeValueIds: _attributeValueIds?.build(),
            avgCost: BuiltValueNullFieldError.checkNotNull(
              avgCost,
              r'ProductVariantResponse',
              'avgCost',
            ),
            totalCostValue: BuiltValueNullFieldError.checkNotNull(
              totalCostValue,
              r'ProductVariantResponse',
              'totalCostValue',
            ),
            totalQtyImported: BuiltValueNullFieldError.checkNotNull(
              totalQtyImported,
              r'ProductVariantResponse',
              'totalQtyImported',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();

        _$failedField = 'attributeValueIds';
        _attributeValueIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ProductVariantResponse',
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
