// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_barcodes_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductBarcodesResponse extends UpdateProductBarcodesResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$UpdateProductBarcodesResponse([
    void Function(UpdateProductBarcodesResponseBuilder)? updates,
  ]) => (UpdateProductBarcodesResponseBuilder()..update(updates))._build();

  _$UpdateProductBarcodesResponse._({required this.success, this.error})
    : super._();
  @override
  UpdateProductBarcodesResponse rebuild(
    void Function(UpdateProductBarcodesResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductBarcodesResponseBuilder toBuilder() =>
      UpdateProductBarcodesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductBarcodesResponse &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductBarcodesResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class UpdateProductBarcodesResponseBuilder
    implements
        Builder<
          UpdateProductBarcodesResponse,
          UpdateProductBarcodesResponseBuilder
        > {
  _$UpdateProductBarcodesResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  UpdateProductBarcodesResponseBuilder() {
    UpdateProductBarcodesResponse._defaults(this);
  }

  UpdateProductBarcodesResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductBarcodesResponse other) {
    _$v = other as _$UpdateProductBarcodesResponse;
  }

  @override
  void update(void Function(UpdateProductBarcodesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductBarcodesResponse build() => _build();

  _$UpdateProductBarcodesResponse _build() {
    final _$result =
        _$v ??
        _$UpdateProductBarcodesResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'UpdateProductBarcodesResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
