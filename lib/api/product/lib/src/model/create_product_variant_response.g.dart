// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_variant_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductVariantResponse extends CreateProductVariantResponse {
  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? variantId;

  factory _$CreateProductVariantResponse([
    void Function(CreateProductVariantResponseBuilder)? updates,
  ]) => (CreateProductVariantResponseBuilder()..update(updates))._build();

  _$CreateProductVariantResponse._({
    required this.success,
    this.error,
    this.variantId,
  }) : super._();
  @override
  CreateProductVariantResponse rebuild(
    void Function(CreateProductVariantResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductVariantResponseBuilder toBuilder() =>
      CreateProductVariantResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductVariantResponse &&
        success == other.success &&
        error == other.error &&
        variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductVariantResponse')
          ..add('success', success)
          ..add('error', error)
          ..add('variantId', variantId))
        .toString();
  }
}

class CreateProductVariantResponseBuilder
    implements
        Builder<
          CreateProductVariantResponse,
          CreateProductVariantResponseBuilder
        > {
  _$CreateProductVariantResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  CreateProductVariantResponseBuilder() {
    CreateProductVariantResponse._defaults(this);
  }

  CreateProductVariantResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductVariantResponse other) {
    _$v = other as _$CreateProductVariantResponse;
  }

  @override
  void update(void Function(CreateProductVariantResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductVariantResponse build() => _build();

  _$CreateProductVariantResponse _build() {
    final _$result =
        _$v ??
        _$CreateProductVariantResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'CreateProductVariantResponse',
            'success',
          ),
          error: error,
          variantId: variantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
