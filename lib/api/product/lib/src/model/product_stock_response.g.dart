// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductStockResponse extends ProductStockResponse {
  @override
  final String orgId;
  @override
  final String productId;
  @override
  final String warehouseId;
  @override
  final double qty;
  @override
  final String? variantId;

  factory _$ProductStockResponse([
    void Function(ProductStockResponseBuilder)? updates,
  ]) => (ProductStockResponseBuilder()..update(updates))._build();

  _$ProductStockResponse._({
    required this.orgId,
    required this.productId,
    required this.warehouseId,
    required this.qty,
    this.variantId,
  }) : super._();
  @override
  ProductStockResponse rebuild(
    void Function(ProductStockResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductStockResponseBuilder toBuilder() =>
      ProductStockResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductStockResponse &&
        orgId == other.orgId &&
        productId == other.productId &&
        warehouseId == other.warehouseId &&
        qty == other.qty &&
        variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, qty.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductStockResponse')
          ..add('orgId', orgId)
          ..add('productId', productId)
          ..add('warehouseId', warehouseId)
          ..add('qty', qty)
          ..add('variantId', variantId))
        .toString();
  }
}

class ProductStockResponseBuilder
    implements Builder<ProductStockResponse, ProductStockResponseBuilder> {
  _$ProductStockResponse? _$v;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  double? _qty;
  double? get qty => _$this._qty;
  set qty(double? qty) => _$this._qty = qty;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  ProductStockResponseBuilder() {
    ProductStockResponse._defaults(this);
  }

  ProductStockResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orgId = $v.orgId;
      _productId = $v.productId;
      _warehouseId = $v.warehouseId;
      _qty = $v.qty;
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductStockResponse other) {
    _$v = other as _$ProductStockResponse;
  }

  @override
  void update(void Function(ProductStockResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductStockResponse build() => _build();

  _$ProductStockResponse _build() {
    final _$result =
        _$v ??
        _$ProductStockResponse._(
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'ProductStockResponse',
            'orgId',
          ),
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'ProductStockResponse',
            'productId',
          ),
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'ProductStockResponse',
            'warehouseId',
          ),
          qty: BuiltValueNullFieldError.checkNotNull(
            qty,
            r'ProductStockResponse',
            'qty',
          ),
          variantId: variantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
