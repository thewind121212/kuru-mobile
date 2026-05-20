// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_product_variants_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveProductVariantsResponse extends SaveProductVariantsResponse {
  @override
  final bool success;
  @override
  final String? error;
  @override
  final BuiltList<ProductVariantResponse>? variants;

  factory _$SaveProductVariantsResponse([
    void Function(SaveProductVariantsResponseBuilder)? updates,
  ]) => (SaveProductVariantsResponseBuilder()..update(updates))._build();

  _$SaveProductVariantsResponse._({
    required this.success,
    this.error,
    this.variants,
  }) : super._();
  @override
  SaveProductVariantsResponse rebuild(
    void Function(SaveProductVariantsResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SaveProductVariantsResponseBuilder toBuilder() =>
      SaveProductVariantsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveProductVariantsResponse &&
        success == other.success &&
        error == other.error &&
        variants == other.variants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveProductVariantsResponse')
          ..add('success', success)
          ..add('error', error)
          ..add('variants', variants))
        .toString();
  }
}

class SaveProductVariantsResponseBuilder
    implements
        Builder<
          SaveProductVariantsResponse,
          SaveProductVariantsResponseBuilder
        > {
  _$SaveProductVariantsResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ListBuilder<ProductVariantResponse>? _variants;
  ListBuilder<ProductVariantResponse> get variants =>
      _$this._variants ??= ListBuilder<ProductVariantResponse>();
  set variants(ListBuilder<ProductVariantResponse>? variants) =>
      _$this._variants = variants;

  SaveProductVariantsResponseBuilder() {
    SaveProductVariantsResponse._defaults(this);
  }

  SaveProductVariantsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _variants = $v.variants?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveProductVariantsResponse other) {
    _$v = other as _$SaveProductVariantsResponse;
  }

  @override
  void update(void Function(SaveProductVariantsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveProductVariantsResponse build() => _build();

  _$SaveProductVariantsResponse _build() {
    _$SaveProductVariantsResponse _$result;
    try {
      _$result =
          _$v ??
          _$SaveProductVariantsResponse._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'SaveProductVariantsResponse',
              'success',
            ),
            error: error,
            variants: _variants?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variants';
        _variants?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SaveProductVariantsResponse',
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
