// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_container_lot_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteContainerLotRequest extends DeleteContainerLotRequest {
  @override
  final String containerLotId;
  @override
  final DeleteLotReason reason;
  @override
  final String? note;

  factory _$DeleteContainerLotRequest([
    void Function(DeleteContainerLotRequestBuilder)? updates,
  ]) => (DeleteContainerLotRequestBuilder()..update(updates))._build();

  _$DeleteContainerLotRequest._({
    required this.containerLotId,
    required this.reason,
    this.note,
  }) : super._();
  @override
  DeleteContainerLotRequest rebuild(
    void Function(DeleteContainerLotRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteContainerLotRequestBuilder toBuilder() =>
      DeleteContainerLotRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteContainerLotRequest &&
        containerLotId == other.containerLotId &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, containerLotId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteContainerLotRequest')
          ..add('containerLotId', containerLotId)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class DeleteContainerLotRequestBuilder
    implements
        Builder<DeleteContainerLotRequest, DeleteContainerLotRequestBuilder> {
  _$DeleteContainerLotRequest? _$v;

  String? _containerLotId;
  String? get containerLotId => _$this._containerLotId;
  set containerLotId(String? containerLotId) =>
      _$this._containerLotId = containerLotId;

  DeleteLotReason? _reason;
  DeleteLotReason? get reason => _$this._reason;
  set reason(DeleteLotReason? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DeleteContainerLotRequestBuilder() {
    DeleteContainerLotRequest._defaults(this);
  }

  DeleteContainerLotRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _containerLotId = $v.containerLotId;
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteContainerLotRequest other) {
    _$v = other as _$DeleteContainerLotRequest;
  }

  @override
  void update(void Function(DeleteContainerLotRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteContainerLotRequest build() => _build();

  _$DeleteContainerLotRequest _build() {
    final _$result =
        _$v ??
        _$DeleteContainerLotRequest._(
          containerLotId: BuiltValueNullFieldError.checkNotNull(
            containerLotId,
            r'DeleteContainerLotRequest',
            'containerLotId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'DeleteContainerLotRequest',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
