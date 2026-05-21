// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_container_lot_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustContainerLotRequest extends AdjustContainerLotRequest {
  @override
  final String containerLotId;
  @override
  final double newQtyRemaining;
  @override
  final ManualAdjustReason reason;
  @override
  final String? note;

  factory _$AdjustContainerLotRequest([
    void Function(AdjustContainerLotRequestBuilder)? updates,
  ]) => (AdjustContainerLotRequestBuilder()..update(updates))._build();

  _$AdjustContainerLotRequest._({
    required this.containerLotId,
    required this.newQtyRemaining,
    required this.reason,
    this.note,
  }) : super._();
  @override
  AdjustContainerLotRequest rebuild(
    void Function(AdjustContainerLotRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustContainerLotRequestBuilder toBuilder() =>
      AdjustContainerLotRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustContainerLotRequest &&
        containerLotId == other.containerLotId &&
        newQtyRemaining == other.newQtyRemaining &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, containerLotId.hashCode);
    _$hash = $jc(_$hash, newQtyRemaining.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdjustContainerLotRequest')
          ..add('containerLotId', containerLotId)
          ..add('newQtyRemaining', newQtyRemaining)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdjustContainerLotRequestBuilder
    implements
        Builder<AdjustContainerLotRequest, AdjustContainerLotRequestBuilder> {
  _$AdjustContainerLotRequest? _$v;

  String? _containerLotId;
  String? get containerLotId => _$this._containerLotId;
  set containerLotId(String? containerLotId) =>
      _$this._containerLotId = containerLotId;

  double? _newQtyRemaining;
  double? get newQtyRemaining => _$this._newQtyRemaining;
  set newQtyRemaining(double? newQtyRemaining) =>
      _$this._newQtyRemaining = newQtyRemaining;

  ManualAdjustReason? _reason;
  ManualAdjustReason? get reason => _$this._reason;
  set reason(ManualAdjustReason? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdjustContainerLotRequestBuilder() {
    AdjustContainerLotRequest._defaults(this);
  }

  AdjustContainerLotRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _containerLotId = $v.containerLotId;
      _newQtyRemaining = $v.newQtyRemaining;
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustContainerLotRequest other) {
    _$v = other as _$AdjustContainerLotRequest;
  }

  @override
  void update(void Function(AdjustContainerLotRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustContainerLotRequest build() => _build();

  _$AdjustContainerLotRequest _build() {
    final _$result =
        _$v ??
        _$AdjustContainerLotRequest._(
          containerLotId: BuiltValueNullFieldError.checkNotNull(
            containerLotId,
            r'AdjustContainerLotRequest',
            'containerLotId',
          ),
          newQtyRemaining: BuiltValueNullFieldError.checkNotNull(
            newQtyRemaining,
            r'AdjustContainerLotRequest',
            'newQtyRemaining',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdjustContainerLotRequest',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
