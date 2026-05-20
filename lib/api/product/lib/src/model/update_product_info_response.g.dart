// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_info_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductInfoResponse extends UpdateProductInfoResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$UpdateProductInfoResponse([
    void Function(UpdateProductInfoResponseBuilder)? updates,
  ]) => (UpdateProductInfoResponseBuilder()..update(updates))._build();

  _$UpdateProductInfoResponse._({required this.success, this.error})
    : super._();
  @override
  UpdateProductInfoResponse rebuild(
    void Function(UpdateProductInfoResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductInfoResponseBuilder toBuilder() =>
      UpdateProductInfoResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductInfoResponse &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductInfoResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class UpdateProductInfoResponseBuilder
    implements
        Builder<UpdateProductInfoResponse, UpdateProductInfoResponseBuilder> {
  _$UpdateProductInfoResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  UpdateProductInfoResponseBuilder() {
    UpdateProductInfoResponse._defaults(this);
  }

  UpdateProductInfoResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductInfoResponse other) {
    _$v = other as _$UpdateProductInfoResponse;
  }

  @override
  void update(void Function(UpdateProductInfoResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductInfoResponse build() => _build();

  _$UpdateProductInfoResponse _build() {
    final _$result =
        _$v ??
        _$UpdateProductInfoResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'UpdateProductInfoResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
