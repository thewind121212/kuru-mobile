// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_variant_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductVariantResponse extends UpdateProductVariantResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$UpdateProductVariantResponse([
    void Function(UpdateProductVariantResponseBuilder)? updates,
  ]) => (UpdateProductVariantResponseBuilder()..update(updates))._build();

  _$UpdateProductVariantResponse._({required this.success, this.error})
    : super._();
  @override
  UpdateProductVariantResponse rebuild(
    void Function(UpdateProductVariantResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductVariantResponseBuilder toBuilder() =>
      UpdateProductVariantResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductVariantResponse &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductVariantResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class UpdateProductVariantResponseBuilder
    implements
        Builder<
          UpdateProductVariantResponse,
          UpdateProductVariantResponseBuilder
        > {
  _$UpdateProductVariantResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  UpdateProductVariantResponseBuilder() {
    UpdateProductVariantResponse._defaults(this);
  }

  UpdateProductVariantResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductVariantResponse other) {
    _$v = other as _$UpdateProductVariantResponse;
  }

  @override
  void update(void Function(UpdateProductVariantResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductVariantResponse build() => _build();

  _$UpdateProductVariantResponse _build() {
    final _$result =
        _$v ??
        _$UpdateProductVariantResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'UpdateProductVariantResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
