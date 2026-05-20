// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_barcode_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductBarcodeResponse extends ProductBarcodeResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String value;
  @override
  final String productId;
  @override
  final bool isActive;
  @override
  final String? variantId;
  @override
  final String? packId;
  @override
  final String kind;

  factory _$ProductBarcodeResponse([
    void Function(ProductBarcodeResponseBuilder)? updates,
  ]) => (ProductBarcodeResponseBuilder()..update(updates))._build();

  _$ProductBarcodeResponse._({
    required this.id,
    required this.orgId,
    required this.value,
    required this.productId,
    required this.isActive,
    this.variantId,
    this.packId,
    required this.kind,
  }) : super._();
  @override
  ProductBarcodeResponse rebuild(
    void Function(ProductBarcodeResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductBarcodeResponseBuilder toBuilder() =>
      ProductBarcodeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductBarcodeResponse &&
        id == other.id &&
        orgId == other.orgId &&
        value == other.value &&
        productId == other.productId &&
        isActive == other.isActive &&
        variantId == other.variantId &&
        packId == other.packId &&
        kind == other.kind;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, packId.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductBarcodeResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('value', value)
          ..add('productId', productId)
          ..add('isActive', isActive)
          ..add('variantId', variantId)
          ..add('packId', packId)
          ..add('kind', kind))
        .toString();
  }
}

class ProductBarcodeResponseBuilder
    implements Builder<ProductBarcodeResponse, ProductBarcodeResponseBuilder> {
  _$ProductBarcodeResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _packId;
  String? get packId => _$this._packId;
  set packId(String? packId) => _$this._packId = packId;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  ProductBarcodeResponseBuilder() {
    ProductBarcodeResponse._defaults(this);
  }

  ProductBarcodeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _value = $v.value;
      _productId = $v.productId;
      _isActive = $v.isActive;
      _variantId = $v.variantId;
      _packId = $v.packId;
      _kind = $v.kind;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductBarcodeResponse other) {
    _$v = other as _$ProductBarcodeResponse;
  }

  @override
  void update(void Function(ProductBarcodeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductBarcodeResponse build() => _build();

  _$ProductBarcodeResponse _build() {
    final _$result =
        _$v ??
        _$ProductBarcodeResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ProductBarcodeResponse',
            'id',
          ),
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'ProductBarcodeResponse',
            'orgId',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'ProductBarcodeResponse',
            'value',
          ),
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'ProductBarcodeResponse',
            'productId',
          ),
          isActive: BuiltValueNullFieldError.checkNotNull(
            isActive,
            r'ProductBarcodeResponse',
            'isActive',
          ),
          variantId: variantId,
          packId: packId,
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'ProductBarcodeResponse',
            'kind',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
