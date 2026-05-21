// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product_variant_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProductVariantRequest extends DeleteProductVariantRequest {
  @override
  final String variantId;

  factory _$DeleteProductVariantRequest([
    void Function(DeleteProductVariantRequestBuilder)? updates,
  ]) => (DeleteProductVariantRequestBuilder()..update(updates))._build();

  _$DeleteProductVariantRequest._({required this.variantId}) : super._();
  @override
  DeleteProductVariantRequest rebuild(
    void Function(DeleteProductVariantRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProductVariantRequestBuilder toBuilder() =>
      DeleteProductVariantRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProductVariantRequest && variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DeleteProductVariantRequest',
    )..add('variantId', variantId)).toString();
  }
}

class DeleteProductVariantRequestBuilder
    implements
        Builder<
          DeleteProductVariantRequest,
          DeleteProductVariantRequestBuilder
        > {
  _$DeleteProductVariantRequest? _$v;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  DeleteProductVariantRequestBuilder() {
    DeleteProductVariantRequest._defaults(this);
  }

  DeleteProductVariantRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteProductVariantRequest other) {
    _$v = other as _$DeleteProductVariantRequest;
  }

  @override
  void update(void Function(DeleteProductVariantRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProductVariantRequest build() => _build();

  _$DeleteProductVariantRequest _build() {
    final _$result =
        _$v ??
        _$DeleteProductVariantRequest._(
          variantId: BuiltValueNullFieldError.checkNotNull(
            variantId,
            r'DeleteProductVariantRequest',
            'variantId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
