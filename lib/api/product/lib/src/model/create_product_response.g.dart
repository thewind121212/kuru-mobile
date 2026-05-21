// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductResponse extends CreateProductResponse {
  @override
  final String? productId;

  factory _$CreateProductResponse([
    void Function(CreateProductResponseBuilder)? updates,
  ]) => (CreateProductResponseBuilder()..update(updates))._build();

  _$CreateProductResponse._({this.productId}) : super._();
  @override
  CreateProductResponse rebuild(
    void Function(CreateProductResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductResponseBuilder toBuilder() =>
      CreateProductResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductResponse && productId == other.productId;
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
      r'CreateProductResponse',
    )..add('productId', productId)).toString();
  }
}

class CreateProductResponseBuilder
    implements Builder<CreateProductResponse, CreateProductResponseBuilder> {
  _$CreateProductResponse? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  CreateProductResponseBuilder() {
    CreateProductResponse._defaults(this);
  }

  CreateProductResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductResponse other) {
    _$v = other as _$CreateProductResponse;
  }

  @override
  void update(void Function(CreateProductResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductResponse build() => _build();

  _$CreateProductResponse _build() {
    final _$result = _$v ?? _$CreateProductResponse._(productId: productId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
