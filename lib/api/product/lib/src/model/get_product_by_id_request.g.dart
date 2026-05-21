// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_by_id_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductByIdRequest extends GetProductByIdRequest {
  @override
  final String productId;

  factory _$GetProductByIdRequest([
    void Function(GetProductByIdRequestBuilder)? updates,
  ]) => (GetProductByIdRequestBuilder()..update(updates))._build();

  _$GetProductByIdRequest._({required this.productId}) : super._();
  @override
  GetProductByIdRequest rebuild(
    void Function(GetProductByIdRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductByIdRequestBuilder toBuilder() =>
      GetProductByIdRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductByIdRequest && productId == other.productId;
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
      r'GetProductByIdRequest',
    )..add('productId', productId)).toString();
  }
}

class GetProductByIdRequestBuilder
    implements Builder<GetProductByIdRequest, GetProductByIdRequestBuilder> {
  _$GetProductByIdRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  GetProductByIdRequestBuilder() {
    GetProductByIdRequest._defaults(this);
  }

  GetProductByIdRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProductByIdRequest other) {
    _$v = other as _$GetProductByIdRequest;
  }

  @override
  void update(void Function(GetProductByIdRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductByIdRequest build() => _build();

  _$GetProductByIdRequest _build() {
    final _$result =
        _$v ??
        _$GetProductByIdRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'GetProductByIdRequest',
            'productId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
