// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_uom_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductUOMResponse extends ProductUOMResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String productId;
  @override
  final String name;
  @override
  final int ratio;
  @override
  final double? sellPrice;
  @override
  final BuiltList<ProductBarcodeResponse>? barcodes;

  factory _$ProductUOMResponse([
    void Function(ProductUOMResponseBuilder)? updates,
  ]) => (ProductUOMResponseBuilder()..update(updates))._build();

  _$ProductUOMResponse._({
    required this.id,
    required this.orgId,
    required this.productId,
    required this.name,
    required this.ratio,
    this.sellPrice,
    this.barcodes,
  }) : super._();
  @override
  ProductUOMResponse rebuild(
    void Function(ProductUOMResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductUOMResponseBuilder toBuilder() =>
      ProductUOMResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductUOMResponse &&
        id == other.id &&
        orgId == other.orgId &&
        productId == other.productId &&
        name == other.name &&
        ratio == other.ratio &&
        sellPrice == other.sellPrice &&
        barcodes == other.barcodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ratio.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, barcodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductUOMResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('productId', productId)
          ..add('name', name)
          ..add('ratio', ratio)
          ..add('sellPrice', sellPrice)
          ..add('barcodes', barcodes))
        .toString();
  }
}

class ProductUOMResponseBuilder
    implements Builder<ProductUOMResponse, ProductUOMResponseBuilder> {
  _$ProductUOMResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _ratio;
  int? get ratio => _$this._ratio;
  set ratio(int? ratio) => _$this._ratio = ratio;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  ListBuilder<ProductBarcodeResponse>? _barcodes;
  ListBuilder<ProductBarcodeResponse> get barcodes =>
      _$this._barcodes ??= ListBuilder<ProductBarcodeResponse>();
  set barcodes(ListBuilder<ProductBarcodeResponse>? barcodes) =>
      _$this._barcodes = barcodes;

  ProductUOMResponseBuilder() {
    ProductUOMResponse._defaults(this);
  }

  ProductUOMResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _productId = $v.productId;
      _name = $v.name;
      _ratio = $v.ratio;
      _sellPrice = $v.sellPrice;
      _barcodes = $v.barcodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductUOMResponse other) {
    _$v = other as _$ProductUOMResponse;
  }

  @override
  void update(void Function(ProductUOMResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductUOMResponse build() => _build();

  _$ProductUOMResponse _build() {
    _$ProductUOMResponse _$result;
    try {
      _$result =
          _$v ??
          _$ProductUOMResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ProductUOMResponse',
              'id',
            ),
            orgId: BuiltValueNullFieldError.checkNotNull(
              orgId,
              r'ProductUOMResponse',
              'orgId',
            ),
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'ProductUOMResponse',
              'productId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ProductUOMResponse',
              'name',
            ),
            ratio: BuiltValueNullFieldError.checkNotNull(
              ratio,
              r'ProductUOMResponse',
              'ratio',
            ),
            sellPrice: sellPrice,
            barcodes: _barcodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'barcodes';
        _barcodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ProductUOMResponse',
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
