// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_container_lot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteContainerLotResponse extends DeleteContainerLotResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$DeleteContainerLotResponse([
    void Function(DeleteContainerLotResponseBuilder)? updates,
  ]) => (DeleteContainerLotResponseBuilder()..update(updates))._build();

  _$DeleteContainerLotResponse._({required this.success, this.error})
    : super._();
  @override
  DeleteContainerLotResponse rebuild(
    void Function(DeleteContainerLotResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteContainerLotResponseBuilder toBuilder() =>
      DeleteContainerLotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteContainerLotResponse &&
        success == other.success &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteContainerLotResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class DeleteContainerLotResponseBuilder
    implements
        Builder<DeleteContainerLotResponse, DeleteContainerLotResponseBuilder> {
  _$DeleteContainerLotResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DeleteContainerLotResponseBuilder() {
    DeleteContainerLotResponse._defaults(this);
  }

  DeleteContainerLotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteContainerLotResponse other) {
    _$v = other as _$DeleteContainerLotResponse;
  }

  @override
  void update(void Function(DeleteContainerLotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteContainerLotResponse build() => _build();

  _$DeleteContainerLotResponse _build() {
    final _$result =
        _$v ??
        _$DeleteContainerLotResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'DeleteContainerLotResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
