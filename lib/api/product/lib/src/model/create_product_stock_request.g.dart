// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_stock_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductStockRequest extends CreateProductStockRequest {
  @override
  final String warehouseId;
  @override
  final double qty;

  factory _$CreateProductStockRequest([
    void Function(CreateProductStockRequestBuilder)? updates,
  ]) => (CreateProductStockRequestBuilder()..update(updates))._build();

  _$CreateProductStockRequest._({required this.warehouseId, required this.qty})
    : super._();
  @override
  CreateProductStockRequest rebuild(
    void Function(CreateProductStockRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductStockRequestBuilder toBuilder() =>
      CreateProductStockRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductStockRequest &&
        warehouseId == other.warehouseId &&
        qty == other.qty;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, qty.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductStockRequest')
          ..add('warehouseId', warehouseId)
          ..add('qty', qty))
        .toString();
  }
}

class CreateProductStockRequestBuilder
    implements
        Builder<CreateProductStockRequest, CreateProductStockRequestBuilder> {
  _$CreateProductStockRequest? _$v;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  double? _qty;
  double? get qty => _$this._qty;
  set qty(double? qty) => _$this._qty = qty;

  CreateProductStockRequestBuilder() {
    CreateProductStockRequest._defaults(this);
  }

  CreateProductStockRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _warehouseId = $v.warehouseId;
      _qty = $v.qty;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductStockRequest other) {
    _$v = other as _$CreateProductStockRequest;
  }

  @override
  void update(void Function(CreateProductStockRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductStockRequest build() => _build();

  _$CreateProductStockRequest _build() {
    final _$result =
        _$v ??
        _$CreateProductStockRequest._(
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'CreateProductStockRequest',
            'warehouseId',
          ),
          qty: BuiltValueNullFieldError.checkNotNull(
            qty,
            r'CreateProductStockRequest',
            'qty',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
