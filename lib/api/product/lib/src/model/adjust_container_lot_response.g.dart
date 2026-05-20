// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_container_lot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustContainerLotResponse extends AdjustContainerLotResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$AdjustContainerLotResponse([
    void Function(AdjustContainerLotResponseBuilder)? updates,
  ]) => (AdjustContainerLotResponseBuilder()..update(updates))._build();

  _$AdjustContainerLotResponse._({required this.success, this.error})
    : super._();
  @override
  AdjustContainerLotResponse rebuild(
    void Function(AdjustContainerLotResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustContainerLotResponseBuilder toBuilder() =>
      AdjustContainerLotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustContainerLotResponse &&
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
    return (newBuiltValueToStringHelper(r'AdjustContainerLotResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class AdjustContainerLotResponseBuilder
    implements
        Builder<AdjustContainerLotResponse, AdjustContainerLotResponseBuilder> {
  _$AdjustContainerLotResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  AdjustContainerLotResponseBuilder() {
    AdjustContainerLotResponse._defaults(this);
  }

  AdjustContainerLotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustContainerLotResponse other) {
    _$v = other as _$AdjustContainerLotResponse;
  }

  @override
  void update(void Function(AdjustContainerLotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustContainerLotResponse build() => _build();

  _$AdjustContainerLotResponse _build() {
    final _$result =
        _$v ??
        _$AdjustContainerLotResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'AdjustContainerLotResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
