// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_move_allocation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockMoveAllocationResponse extends StockMoveAllocationResponse {
  @override
  final String warehouseId;
  @override
  final String? lotId;
  @override
  final double qtyTaken;

  factory _$StockMoveAllocationResponse([
    void Function(StockMoveAllocationResponseBuilder)? updates,
  ]) => (StockMoveAllocationResponseBuilder()..update(updates))._build();

  _$StockMoveAllocationResponse._({
    required this.warehouseId,
    this.lotId,
    required this.qtyTaken,
  }) : super._();
  @override
  StockMoveAllocationResponse rebuild(
    void Function(StockMoveAllocationResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  StockMoveAllocationResponseBuilder toBuilder() =>
      StockMoveAllocationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockMoveAllocationResponse &&
        warehouseId == other.warehouseId &&
        lotId == other.lotId &&
        qtyTaken == other.qtyTaken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, lotId.hashCode);
    _$hash = $jc(_$hash, qtyTaken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StockMoveAllocationResponse')
          ..add('warehouseId', warehouseId)
          ..add('lotId', lotId)
          ..add('qtyTaken', qtyTaken))
        .toString();
  }
}

class StockMoveAllocationResponseBuilder
    implements
        Builder<
          StockMoveAllocationResponse,
          StockMoveAllocationResponseBuilder
        > {
  _$StockMoveAllocationResponse? _$v;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  String? _lotId;
  String? get lotId => _$this._lotId;
  set lotId(String? lotId) => _$this._lotId = lotId;

  double? _qtyTaken;
  double? get qtyTaken => _$this._qtyTaken;
  set qtyTaken(double? qtyTaken) => _$this._qtyTaken = qtyTaken;

  StockMoveAllocationResponseBuilder() {
    StockMoveAllocationResponse._defaults(this);
  }

  StockMoveAllocationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _warehouseId = $v.warehouseId;
      _lotId = $v.lotId;
      _qtyTaken = $v.qtyTaken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockMoveAllocationResponse other) {
    _$v = other as _$StockMoveAllocationResponse;
  }

  @override
  void update(void Function(StockMoveAllocationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StockMoveAllocationResponse build() => _build();

  _$StockMoveAllocationResponse _build() {
    final _$result =
        _$v ??
        _$StockMoveAllocationResponse._(
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'StockMoveAllocationResponse',
            'warehouseId',
          ),
          lotId: lotId,
          qtyTaken: BuiltValueNullFieldError.checkNotNull(
            qtyTaken,
            r'StockMoveAllocationResponse',
            'qtyTaken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
