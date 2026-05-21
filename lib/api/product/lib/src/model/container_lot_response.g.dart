// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_lot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContainerLotResponse extends ContainerLotResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String warehouseId;
  @override
  final String productId;
  @override
  final double qtyInitial;
  @override
  final double qtyRemaining;
  @override
  final String? barcode;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final DateTime createdAt;

  factory _$ContainerLotResponse([
    void Function(ContainerLotResponseBuilder)? updates,
  ]) => (ContainerLotResponseBuilder()..update(updates))._build();

  _$ContainerLotResponse._({
    required this.id,
    required this.orgId,
    required this.warehouseId,
    required this.productId,
    required this.qtyInitial,
    required this.qtyRemaining,
    this.barcode,
    this.variantId,
    this.variantName,
    required this.createdAt,
  }) : super._();
  @override
  ContainerLotResponse rebuild(
    void Function(ContainerLotResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContainerLotResponseBuilder toBuilder() =>
      ContainerLotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContainerLotResponse &&
        id == other.id &&
        orgId == other.orgId &&
        warehouseId == other.warehouseId &&
        productId == other.productId &&
        qtyInitial == other.qtyInitial &&
        qtyRemaining == other.qtyRemaining &&
        barcode == other.barcode &&
        variantId == other.variantId &&
        variantName == other.variantName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, qtyInitial.hashCode);
    _$hash = $jc(_$hash, qtyRemaining.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, variantName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContainerLotResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('warehouseId', warehouseId)
          ..add('productId', productId)
          ..add('qtyInitial', qtyInitial)
          ..add('qtyRemaining', qtyRemaining)
          ..add('barcode', barcode)
          ..add('variantId', variantId)
          ..add('variantName', variantName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ContainerLotResponseBuilder
    implements Builder<ContainerLotResponse, ContainerLotResponseBuilder> {
  _$ContainerLotResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

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

  String? _variantName;
  String? get variantName => _$this._variantName;
  set variantName(String? variantName) => _$this._variantName = variantName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ContainerLotResponseBuilder() {
    ContainerLotResponse._defaults(this);
  }

  ContainerLotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _warehouseId = $v.warehouseId;
      _productId = $v.productId;
      _qtyInitial = $v.qtyInitial;
      _qtyRemaining = $v.qtyRemaining;
      _barcode = $v.barcode;
      _variantId = $v.variantId;
      _variantName = $v.variantName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContainerLotResponse other) {
    _$v = other as _$ContainerLotResponse;
  }

  @override
  void update(void Function(ContainerLotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContainerLotResponse build() => _build();

  _$ContainerLotResponse _build() {
    final _$result =
        _$v ??
        _$ContainerLotResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ContainerLotResponse',
            'id',
          ),
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'ContainerLotResponse',
            'orgId',
          ),
          warehouseId: BuiltValueNullFieldError.checkNotNull(
            warehouseId,
            r'ContainerLotResponse',
            'warehouseId',
          ),
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'ContainerLotResponse',
            'productId',
          ),
          qtyInitial: BuiltValueNullFieldError.checkNotNull(
            qtyInitial,
            r'ContainerLotResponse',
            'qtyInitial',
          ),
          qtyRemaining: BuiltValueNullFieldError.checkNotNull(
            qtyRemaining,
            r'ContainerLotResponse',
            'qtyRemaining',
          ),
          barcode: barcode,
          variantId: variantId,
          variantName: variantName,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'ContainerLotResponse',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
