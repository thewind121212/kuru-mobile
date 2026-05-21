// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_container_lots_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetContainerLotsRequest extends GetContainerLotsRequest {
  @override
  final String productId;
  @override
  final String? variantId;

  factory _$GetContainerLotsRequest([
    void Function(GetContainerLotsRequestBuilder)? updates,
  ]) => (GetContainerLotsRequestBuilder()..update(updates))._build();

  _$GetContainerLotsRequest._({required this.productId, this.variantId})
    : super._();
  @override
  GetContainerLotsRequest rebuild(
    void Function(GetContainerLotsRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetContainerLotsRequestBuilder toBuilder() =>
      GetContainerLotsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetContainerLotsRequest &&
        productId == other.productId &&
        variantId == other.variantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetContainerLotsRequest')
          ..add('productId', productId)
          ..add('variantId', variantId))
        .toString();
  }
}

class GetContainerLotsRequestBuilder
    implements
        Builder<GetContainerLotsRequest, GetContainerLotsRequestBuilder> {
  _$GetContainerLotsRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  GetContainerLotsRequestBuilder() {
    GetContainerLotsRequest._defaults(this);
  }

  GetContainerLotsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _variantId = $v.variantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetContainerLotsRequest other) {
    _$v = other as _$GetContainerLotsRequest;
  }

  @override
  void update(void Function(GetContainerLotsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetContainerLotsRequest build() => _build();

  _$GetContainerLotsRequest _build() {
    final _$result =
        _$v ??
        _$GetContainerLotsRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'GetContainerLotsRequest',
            'productId',
          ),
          variantId: variantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
