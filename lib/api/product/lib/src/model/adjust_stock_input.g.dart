// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_stock_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustStockInput extends AdjustStockInput {
  @override
  final String warehouseId;
  @override
  final double quantity;
  @override
  final String? variantId;

  factory _$AdjustStockInput([
    void Function(AdjustStockInputBuilder)? updates,
  ]) => (AdjustStockInputBuilder()..update(updates))._build();

  _$AdjustStockInput._({
    required this.warehouseId,
    required this.quantity,
    this.variantId,
  }) : super._();
  @override
  AdjustStockInput rebuild(void Function(AdjustStockInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdjustStockInputBuilder toBuilder() =>
      AdjustStockInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustStockInput &&
        warehouseId == other.warehouseId &&
        quantity == other.quantity &&
        variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdjustStockInput')
          ..add('warehouseId', warehouseId)
          ..add('quantity', quantity)
          ..add('variantId', variantId))
        .toString();
  }
}

class AdjustStockInputBuilder
    implements Builder<AdjustStockInput, AdjustStockInputBuilder> {
  _$AdjustStockInput? _$v;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  double? _quantity;
  double? get quantity => _$this._quantity;
  set quantity(double? quantity) => _$this._quantity = quantity;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  AdjustStockInputBuilder() {
    AdjustStockInput._defaults(this);
  }

  AdjustStockInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _warehouseId = $v.warehouseId;
      _quantity = $v.quantity;
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustStockInput other) {
    _$v = other as _$AdjustStockInput;
  }

  @override
  void update(void Function(AdjustStockInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustStockInput build() => _build();

  _$AdjustStockInput _build() {
    final _$result =
        _$v ??
        _$AdjustStockInput._(
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'AdjustStockInput',
            'warehouseId',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdjustStockInput',
            'quantity',
          ),
          variantId: variantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
