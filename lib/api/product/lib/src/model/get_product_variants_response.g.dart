// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_variants_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductVariantsResponse extends GetProductVariantsResponse {
  @override
  final BuiltList<ProductVariantResponse>? variants;

  factory _$GetProductVariantsResponse([
    void Function(GetProductVariantsResponseBuilder)? updates,
  ]) => (GetProductVariantsResponseBuilder()..update(updates))._build();

  _$GetProductVariantsResponse._({this.variants}) : super._();
  @override
  GetProductVariantsResponse rebuild(
    void Function(GetProductVariantsResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductVariantsResponseBuilder toBuilder() =>
      GetProductVariantsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductVariantsResponse && variants == other.variants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GetProductVariantsResponse',
    )..add('variants', variants)).toString();
  }
}

class GetProductVariantsResponseBuilder
    implements
        Builder<GetProductVariantsResponse, GetProductVariantsResponseBuilder> {
  _$GetProductVariantsResponse? _$v;

  ListBuilder<ProductVariantResponse>? _variants;
  ListBuilder<ProductVariantResponse> get variants =>
      _$this._variants ??= ListBuilder<ProductVariantResponse>();
  set variants(ListBuilder<ProductVariantResponse>? variants) =>
      _$this._variants = variants;

  GetProductVariantsResponseBuilder() {
    GetProductVariantsResponse._defaults(this);
  }

  GetProductVariantsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variants = $v.variants?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProductVariantsResponse other) {
    _$v = other as _$GetProductVariantsResponse;
  }

  @override
  void update(void Function(GetProductVariantsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductVariantsResponse build() => _build();

  _$GetProductVariantsResponse _build() {
    _$GetProductVariantsResponse _$result;
    try {
      _$result =
          _$v ?? _$GetProductVariantsResponse._(variants: _variants?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variants';
        _variants?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetProductVariantsResponse',
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
