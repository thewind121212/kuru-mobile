// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_barcodes_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductBarcodesRequest extends UpdateProductBarcodesRequest {
  @override
  final String productId;
  @override
  final BuiltList<UpsertBarcodeInput>? upsertBarcodes;
  @override
  final BuiltList<String>? removeBarcodeIds;

  factory _$UpdateProductBarcodesRequest([
    void Function(UpdateProductBarcodesRequestBuilder)? updates,
  ]) => (UpdateProductBarcodesRequestBuilder()..update(updates))._build();

  _$UpdateProductBarcodesRequest._({
    required this.productId,
    this.upsertBarcodes,
    this.removeBarcodeIds,
  }) : super._();
  @override
  UpdateProductBarcodesRequest rebuild(
    void Function(UpdateProductBarcodesRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductBarcodesRequestBuilder toBuilder() =>
      UpdateProductBarcodesRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductBarcodesRequest &&
        productId == other.productId &&
        upsertBarcodes == other.upsertBarcodes &&
        removeBarcodeIds == other.removeBarcodeIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, upsertBarcodes.hashCode);
    _$hash = $jc(_$hash, removeBarcodeIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateProductBarcodesRequest')
          ..add('productId', productId)
          ..add('upsertBarcodes', upsertBarcodes)
          ..add('removeBarcodeIds', removeBarcodeIds))
        .toString();
  }
}

class UpdateProductBarcodesRequestBuilder
    implements
        Builder<
          UpdateProductBarcodesRequest,
          UpdateProductBarcodesRequestBuilder
        > {
  _$UpdateProductBarcodesRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  ListBuilder<UpsertBarcodeInput>? _upsertBarcodes;
  ListBuilder<UpsertBarcodeInput> get upsertBarcodes =>
      _$this._upsertBarcodes ??= ListBuilder<UpsertBarcodeInput>();
  set upsertBarcodes(ListBuilder<UpsertBarcodeInput>? upsertBarcodes) =>
      _$this._upsertBarcodes = upsertBarcodes;

  ListBuilder<String>? _removeBarcodeIds;
  ListBuilder<String> get removeBarcodeIds =>
      _$this._removeBarcodeIds ??= ListBuilder<String>();
  set removeBarcodeIds(ListBuilder<String>? removeBarcodeIds) =>
      _$this._removeBarcodeIds = removeBarcodeIds;

  UpdateProductBarcodesRequestBuilder() {
    UpdateProductBarcodesRequest._defaults(this);
  }

  UpdateProductBarcodesRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _upsertBarcodes = $v.upsertBarcodes?.toBuilder();
      _removeBarcodeIds = $v.removeBarcodeIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductBarcodesRequest other) {
    _$v = other as _$UpdateProductBarcodesRequest;
  }

  @override
  void update(void Function(UpdateProductBarcodesRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductBarcodesRequest build() => _build();

  _$UpdateProductBarcodesRequest _build() {
    _$UpdateProductBarcodesRequest _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductBarcodesRequest._(
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'UpdateProductBarcodesRequest',
              'productId',
            ),
            upsertBarcodes: _upsertBarcodes?.build(),
            removeBarcodeIds: _removeBarcodeIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'upsertBarcodes';
        _upsertBarcodes?.build();
        _$failedField = 'removeBarcodeIds';
        _removeBarcodeIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateProductBarcodesRequest',
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
