// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_container_lot_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateContainerLotInput extends CreateContainerLotInput {
  @override
  final String warehouseId;
  @override
  final double qtyInitial;
  @override
  final double? qtyRemaining;
  @override
  final String? barcode;
  @override
  final String? variantId;

  factory _$CreateContainerLotInput([
    void Function(CreateContainerLotInputBuilder)? updates,
  ]) => (CreateContainerLotInputBuilder()..update(updates))._build();

  _$CreateContainerLotInput._({
    required this.warehouseId,
    required this.qtyInitial,
    this.qtyRemaining,
    this.barcode,
    this.variantId,
  }) : super._();
  @override
  CreateContainerLotInput rebuild(
    void Function(CreateContainerLotInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateContainerLotInputBuilder toBuilder() =>
      CreateContainerLotInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateContainerLotInput &&
        warehouseId == other.warehouseId &&
        qtyInitial == other.qtyInitial &&
        qtyRemaining == other.qtyRemaining &&
        barcode == other.barcode &&
        variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, qtyInitial.hashCode);
    _$hash = $jc(_$hash, qtyRemaining.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateContainerLotInput')
          ..add('warehouseId', warehouseId)
          ..add('qtyInitial', qtyInitial)
          ..add('qtyRemaining', qtyRemaining)
          ..add('barcode', barcode)
          ..add('variantId', variantId))
        .toString();
  }
}

class CreateContainerLotInputBuilder
    implements
        Builder<CreateContainerLotInput, CreateContainerLotInputBuilder> {
  _$CreateContainerLotInput? _$v;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  double? _qtyInitial;
  double? get qtyInitial => _$this._qtyInitial;
  set qtyInitial(double? qtyInitial) => _$this._qtyInitial = qtyInitial;

  double? _qtyRemaining;
  double? get qtyRemaining => _$this._qtyRemaining;
  set qtyRemaining(double? qtyRemaining) => _$this._qtyRemaining = qtyRemaining;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  CreateContainerLotInputBuilder() {
    CreateContainerLotInput._defaults(this);
  }

  CreateContainerLotInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _warehouseId = $v.warehouseId;
      _qtyInitial = $v.qtyInitial;
      _qtyRemaining = $v.qtyRemaining;
      _barcode = $v.barcode;
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateContainerLotInput other) {
    _$v = other as _$CreateContainerLotInput;
  }

  @override
  void update(void Function(CreateContainerLotInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateContainerLotInput build() => _build();

  _$CreateContainerLotInput _build() {
    final _$result =
        _$v ??
        _$CreateContainerLotInput._(
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'CreateContainerLotInput',
            'warehouseId',
          ),
          qtyInitial: BuiltValueNullFieldError.checkNotNull(
            qtyInitial,
            r'CreateContainerLotInput',
            'qtyInitial',
          ),
          qtyRemaining: qtyRemaining,
          barcode: barcode,
          variantId: variantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
