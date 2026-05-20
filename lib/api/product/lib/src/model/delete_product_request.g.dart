// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProductRequest extends DeleteProductRequest {
  @override
  final String productId;

  factory _$DeleteProductRequest([
    void Function(DeleteProductRequestBuilder)? updates,
  ]) => (DeleteProductRequestBuilder()..update(updates))._build();

  _$DeleteProductRequest._({required this.productId}) : super._();
  @override
  DeleteProductRequest rebuild(
    void Function(DeleteProductRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProductRequestBuilder toBuilder() =>
      DeleteProductRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProductRequest && productId == other.productId;
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
      r'DeleteProductRequest',
    )..add('productId', productId)).toString();
  }
}

class DeleteProductRequestBuilder
    implements Builder<DeleteProductRequest, DeleteProductRequestBuilder> {
  _$DeleteProductRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  DeleteProductRequestBuilder() {
    DeleteProductRequest._defaults(this);
  }

  DeleteProductRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteProductRequest other) {
    _$v = other as _$DeleteProductRequest;
  }

  @override
  void update(void Function(DeleteProductRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProductRequest build() => _build();

  _$DeleteProductRequest _build() {
    final _$result =
        _$v ??
        _$DeleteProductRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'DeleteProductRequest',
            'productId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
