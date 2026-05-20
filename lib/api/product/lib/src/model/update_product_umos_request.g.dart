// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_umos_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductUmosRequest extends UpdateProductUmosRequest {
  @override
  final String productId;
  @override
  final BuiltList<UpsertUmoInput>? upsertUmos;
  @override
  final BuiltList<String>? removeUmoIds;

  factory _$UpdateProductUmosRequest([
    void Function(UpdateProductUmosRequestBuilder)? updates,
  ]) => (UpdateProductUmosRequestBuilder()..update(updates))._build();

  _$UpdateProductUmosRequest._({
    required this.productId,
    this.upsertUmos,
    this.removeUmoIds,
  }) : super._();
  @override
  UpdateProductUmosRequest rebuild(
    void Function(UpdateProductUmosRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductUmosRequestBuilder toBuilder() =>
      UpdateProductUmosRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductUmosRequest &&
        productId == other.productId &&
        upsertUmos == other.upsertUmos &&
        removeUmoIds == other.removeUmoIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, upsertUmos.hashCode);
    _$hash = $jc(_$hash, removeUmoIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateProductUmosRequest')
          ..add('productId', productId)
          ..add('upsertUmos', upsertUmos)
          ..add('removeUmoIds', removeUmoIds))
        .toString();
  }
}

class UpdateProductUmosRequestBuilder
    implements
        Builder<UpdateProductUmosRequest, UpdateProductUmosRequestBuilder> {
  _$UpdateProductUmosRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  ListBuilder<UpsertUmoInput>? _upsertUmos;
  ListBuilder<UpsertUmoInput> get upsertUmos =>
      _$this._upsertUmos ??= ListBuilder<UpsertUmoInput>();
  set upsertUmos(ListBuilder<UpsertUmoInput>? upsertUmos) =>
      _$this._upsertUmos = upsertUmos;

  ListBuilder<String>? _removeUmoIds;
  ListBuilder<String> get removeUmoIds =>
      _$this._removeUmoIds ??= ListBuilder<String>();
  set removeUmoIds(ListBuilder<String>? removeUmoIds) =>
      _$this._removeUmoIds = removeUmoIds;

  UpdateProductUmosRequestBuilder() {
    UpdateProductUmosRequest._defaults(this);
  }

  UpdateProductUmosRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _upsertUmos = $v.upsertUmos?.toBuilder();
      _removeUmoIds = $v.removeUmoIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductUmosRequest other) {
    _$v = other as _$UpdateProductUmosRequest;
  }

  @override
  void update(void Function(UpdateProductUmosRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductUmosRequest build() => _build();

  _$UpdateProductUmosRequest _build() {
    _$UpdateProductUmosRequest _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductUmosRequest._(
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'UpdateProductUmosRequest',
              'productId',
            ),
            upsertUmos: _upsertUmos?.build(),
            removeUmoIds: _removeUmoIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'upsertUmos';
        _upsertUmos?.build();
        _$failedField = 'removeUmoIds';
        _removeUmoIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateProductUmosRequest',
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
