// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_variants_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductVariantsRequest extends GetProductVariantsRequest {
  @override
  final String productId;

  factory _$GetProductVariantsRequest([
    void Function(GetProductVariantsRequestBuilder)? updates,
  ]) => (GetProductVariantsRequestBuilder()..update(updates))._build();

  _$GetProductVariantsRequest._({required this.productId}) : super._();
  @override
  GetProductVariantsRequest rebuild(
    void Function(GetProductVariantsRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductVariantsRequestBuilder toBuilder() =>
      GetProductVariantsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductVariantsRequest && productId == other.productId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GetProductVariantsRequest',
    )..add('productId', productId)).toString();
  }
}

class GetProductVariantsRequestBuilder
    implements
        Builder<GetProductVariantsRequest, GetProductVariantsRequestBuilder> {
  _$GetProductVariantsRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  GetProductVariantsRequestBuilder() {
    GetProductVariantsRequest._defaults(this);
  }

  GetProductVariantsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProductVariantsRequest other) {
    _$v = other as _$GetProductVariantsRequest;
  }

  @override
  void update(void Function(GetProductVariantsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductVariantsRequest build() => _build();

  _$GetProductVariantsRequest _build() {
    final _$result =
        _$v ??
        _$GetProductVariantsRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'GetProductVariantsRequest',
            'productId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
