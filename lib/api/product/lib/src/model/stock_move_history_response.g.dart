// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_move_history_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockMoveHistoryResponse extends StockMoveHistoryResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String productId;
  @override
  final String type;
  @override
  final String sourceType;
  @override
  final double qtyBase;
  @override
  final String? uomLabel;
  @override
  final double? uomQty;
  @override
  final double? uomRatio;
  @override
  final DateTime createdAt;
  @override
  final String actorUserId;
  @override
  final BuiltList<StockMoveAllocationResponse>? allocations;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String? warehouseName;
  @override
  final String? fromWarehouseName;
  @override
  final String? toWarehouseName;
  @override
  final String? reason;
  @override
  final String? note;

  factory _$StockMoveHistoryResponse([
    void Function(StockMoveHistoryResponseBuilder)? updates,
  ]) => (StockMoveHistoryResponseBuilder()..update(updates))._build();

  _$StockMoveHistoryResponse._({
    required this.id,
    required this.orgId,
    required this.productId,
    required this.type,
    required this.sourceType,
    required this.qtyBase,
    this.uomLabel,
    this.uomQty,
    this.uomRatio,
    required this.createdAt,
    required this.actorUserId,
    this.allocations,
    this.variantId,
    this.variantName,
    this.warehouseName,
    this.fromWarehouseName,
    this.toWarehouseName,
    this.reason,
    this.note,
  }) : super._();
  @override
  StockMoveHistoryResponse rebuild(
    void Function(StockMoveHistoryResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  StockMoveHistoryResponseBuilder toBuilder() =>
      StockMoveHistoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockMoveHistoryResponse &&
        id == other.id &&
        orgId == other.orgId &&
        productId == other.productId &&
        type == other.type &&
        sourceType == other.sourceType &&
        qtyBase == other.qtyBase &&
        uomLabel == other.uomLabel &&
        uomQty == other.uomQty &&
        uomRatio == other.uomRatio &&
        createdAt == other.createdAt &&
        actorUserId == other.actorUserId &&
        allocations == other.allocations &&
        variantId == other.variantId &&
        variantName == other.variantName &&
        warehouseName == other.warehouseName &&
        fromWarehouseName == other.fromWarehouseName &&
        toWarehouseName == other.toWarehouseName &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, qtyBase.hashCode);
    _$hash = $jc(_$hash, uomLabel.hashCode);
    _$hash = $jc(_$hash, uomQty.hashCode);
    _$hash = $jc(_$hash, uomRatio.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, actorUserId.hashCode);
    _$hash = $jc(_$hash, allocations.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, variantName.hashCode);
    _$hash = $jc(_$hash, warehouseName.hashCode);
    _$hash = $jc(_$hash, fromWarehouseName.hashCode);
    _$hash = $jc(_$hash, toWarehouseName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StockMoveHistoryResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('productId', productId)
          ..add('type', type)
          ..add('sourceType', sourceType)
          ..add('qtyBase', qtyBase)
          ..add('uomLabel', uomLabel)
          ..add('uomQty', uomQty)
          ..add('uomRatio', uomRatio)
          ..add('createdAt', createdAt)
          ..add('actorUserId', actorUserId)
          ..add('allocations', allocations)
          ..add('variantId', variantId)
          ..add('variantName', variantName)
          ..add('warehouseName', warehouseName)
          ..add('fromWarehouseName', fromWarehouseName)
          ..add('toWarehouseName', toWarehouseName)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class StockMoveHistoryResponseBuilder
    implements
        Builder<StockMoveHistoryResponse, StockMoveHistoryResponseBuilder> {
  _$StockMoveHistoryResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  double? _qtyBase;
  double? get qtyBase => _$this._qtyBase;
  set qtyBase(double? qtyBase) => _$this._qtyBase = qtyBase;

  String? _uomLabel;
  String? get uomLabel => _$this._uomLabel;
  set uomLabel(String? uomLabel) => _$this._uomLabel = uomLabel;

  double? _uomQty;
  double? get uomQty => _$this._uomQty;
  set uomQty(double? uomQty) => _$this._uomQty = uomQty;

  double? _uomRatio;
  double? get uomRatio => _$this._uomRatio;
  set uomRatio(double? uomRatio) => _$this._uomRatio = uomRatio;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _actorUserId;
  String? get actorUserId => _$this._actorUserId;
  set actorUserId(String? actorUserId) => _$this._actorUserId = actorUserId;

  ListBuilder<StockMoveAllocationResponse>? _allocations;
  ListBuilder<StockMoveAllocationResponse> get allocations =>
      _$this._allocations ??= ListBuilder<StockMoveAllocationResponse>();
  set allocations(ListBuilder<StockMoveAllocationResponse>? allocations) =>
      _$this._allocations = allocations;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _variantName;
  String? get variantName => _$this._variantName;
  set variantName(String? variantName) => _$this._variantName = variantName;

  String? _warehouseName;
  String? get warehouseName => _$this._warehouseName;
  set warehouseName(String? warehouseName) =>
      _$this._warehouseName = warehouseName;

  String? _fromWarehouseName;
  String? get fromWarehouseName => _$this._fromWarehouseName;
  set fromWarehouseName(String? fromWarehouseName) =>
      _$this._fromWarehouseName = fromWarehouseName;

  String? _toWarehouseName;
  String? get toWarehouseName => _$this._toWarehouseName;
  set toWarehouseName(String? toWarehouseName) =>
      _$this._toWarehouseName = toWarehouseName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  StockMoveHistoryResponseBuilder() {
    StockMoveHistoryResponse._defaults(this);
  }

  StockMoveHistoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _productId = $v.productId;
      _type = $v.type;
      _sourceType = $v.sourceType;
      _qtyBase = $v.qtyBase;
      _uomLabel = $v.uomLabel;
      _uomQty = $v.uomQty;
      _uomRatio = $v.uomRatio;
      _createdAt = $v.createdAt;
      _actorUserId = $v.actorUserId;
      _allocations = $v.allocations?.toBuilder();
      _variantId = $v.variantId;
      _variantName = $v.variantName;
      _warehouseName = $v.warehouseName;
      _fromWarehouseName = $v.fromWarehouseName;
      _toWarehouseName = $v.toWarehouseName;
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockMoveHistoryResponse other) {
    _$v = other as _$StockMoveHistoryResponse;
  }

  @override
  void update(void Function(StockMoveHistoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StockMoveHistoryResponse build() => _build();

  _$StockMoveHistoryResponse _build() {
    _$StockMoveHistoryResponse _$result;
    try {
      _$result =
          _$v ??
          _$StockMoveHistoryResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'StockMoveHistoryResponse',
              'id',
            ),
            orgId: BuiltValueNullFieldError.checkNotNull(
              orgId,
              r'StockMoveHistoryResponse',
              'orgId',
            ),
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'StockMoveHistoryResponse',
              'productId',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'StockMoveHistoryResponse',
              'type',
            ),
            sourceType: BuiltValueNullFieldError.checkNotNull(
              sourceType,
              r'StockMoveHistoryResponse',
              'sourceType',
            ),
            qtyBase: BuiltValueNullFieldError.checkNotNull(
              qtyBase,
              r'StockMoveHistoryResponse',
              'qtyBase',
            ),
            uomLabel: uomLabel,
            uomQty: uomQty,
            uomRatio: uomRatio,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'StockMoveHistoryResponse',
              'createdAt',
            ),
            actorUserId: BuiltValueNullFieldError.checkNotNull(
              actorUserId,
              r'StockMoveHistoryResponse',
              'actorUserId',
            ),
            allocations: _allocations?.build(),
            variantId: variantId,
            variantName: variantName,
            warehouseName: warehouseName,
            fromWarehouseName: fromWarehouseName,
            toWarehouseName: toWarehouseName,
            reason: reason,
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allocations';
        _allocations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'StockMoveHistoryResponse',
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
