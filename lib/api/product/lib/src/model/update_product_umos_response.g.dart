// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_umos_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductUmosResponse extends UpdateProductUmosResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$UpdateProductUmosResponse([
    void Function(UpdateProductUmosResponseBuilder)? updates,
  ]) => (UpdateProductUmosResponseBuilder()..update(updates))._build();

  _$UpdateProductUmosResponse._({required this.success, this.error})
    : super._();
  @override
  UpdateProductUmosResponse rebuild(
    void Function(UpdateProductUmosResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductUmosResponseBuilder toBuilder() =>
      UpdateProductUmosResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductUmosResponse &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductUmosResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class UpdateProductUmosResponseBuilder
    implements
        Builder<UpdateProductUmosResponse, UpdateProductUmosResponseBuilder> {
  _$UpdateProductUmosResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  UpdateProductUmosResponseBuilder() {
    UpdateProductUmosResponse._defaults(this);
  }

  UpdateProductUmosResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductUmosResponse other) {
    _$v = other as _$UpdateProductUmosResponse;
  }

  @override
  void update(void Function(UpdateProductUmosResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductUmosResponse build() => _build();

  _$UpdateProductUmosResponse _build() {
    final _$result =
        _$v ??
        _$UpdateProductUmosResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'UpdateProductUmosResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
