// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_product_variants_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveProductVariantsRequest extends SaveProductVariantsRequest {
  @override
  final String productId;
  @override
  final BuiltList<VariantInput>? variants;
  @override
  final BuiltList<String>? deleteVariantIds;

  factory _$SaveProductVariantsRequest([
    void Function(SaveProductVariantsRequestBuilder)? updates,
  ]) => (SaveProductVariantsRequestBuilder()..update(updates))._build();

  _$SaveProductVariantsRequest._({
    required this.productId,
    this.variants,
    this.deleteVariantIds,
  }) : super._();
  @override
  SaveProductVariantsRequest rebuild(
    void Function(SaveProductVariantsRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SaveProductVariantsRequestBuilder toBuilder() =>
      SaveProductVariantsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveProductVariantsRequest &&
        productId == other.productId &&
        variants == other.variants &&
        deleteVariantIds == other.deleteVariantIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, deleteVariantIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveProductVariantsRequest')
          ..add('productId', productId)
          ..add('variants', variants)
          ..add('deleteVariantIds', deleteVariantIds))
        .toString();
  }
}

class SaveProductVariantsRequestBuilder
    implements
        Builder<SaveProductVariantsRequest, SaveProductVariantsRequestBuilder> {
  _$SaveProductVariantsRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  ListBuilder<VariantInput>? _variants;
  ListBuilder<VariantInput> get variants =>
      _$this._variants ??= ListBuilder<VariantInput>();
  set variants(ListBuilder<VariantInput>? variants) =>
      _$this._variants = variants;

  ListBuilder<String>? _deleteVariantIds;
  ListBuilder<String> get deleteVariantIds =>
      _$this._deleteVariantIds ??= ListBuilder<String>();
  set deleteVariantIds(ListBuilder<String>? deleteVariantIds) =>
      _$this._deleteVariantIds = deleteVariantIds;

  SaveProductVariantsRequestBuilder() {
    SaveProductVariantsRequest._defaults(this);
  }

  SaveProductVariantsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _variants = $v.variants?.toBuilder();
      _deleteVariantIds = $v.deleteVariantIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveProductVariantsRequest other) {
    _$v = other as _$SaveProductVariantsRequest;
  }

  @override
  void update(void Function(SaveProductVariantsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveProductVariantsRequest build() => _build();

  _$SaveProductVariantsRequest _build() {
    _$SaveProductVariantsRequest _$result;
    try {
      _$result =
          _$v ??
          _$SaveProductVariantsRequest._(
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'SaveProductVariantsRequest',
              'productId',
            ),
            variants: _variants?.build(),
            deleteVariantIds: _deleteVariantIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variants';
        _variants?.build();
        _$failedField = 'deleteVariantIds';
        _deleteVariantIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SaveProductVariantsRequest',
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
