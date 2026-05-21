// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_variant_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductVariantRequest extends CreateProductVariantRequest {
  @override
  final String productId;
  @override
  final String name;
  @override
  final double? sellPrice;
  @override
  final double? exportPrice;
  @override
  final double? importPrice;

  factory _$CreateProductVariantRequest([
    void Function(CreateProductVariantRequestBuilder)? updates,
  ]) => (CreateProductVariantRequestBuilder()..update(updates))._build();

  _$CreateProductVariantRequest._({
    required this.productId,
    required this.name,
    this.sellPrice,
    this.exportPrice,
    this.importPrice,
  }) : super._();
  @override
  CreateProductVariantRequest rebuild(
    void Function(CreateProductVariantRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductVariantRequestBuilder toBuilder() =>
      CreateProductVariantRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductVariantRequest &&
        productId == other.productId &&
        name == other.name &&
        sellPrice == other.sellPrice &&
        exportPrice == other.exportPrice &&
        importPrice == other.importPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductVariantRequest')
          ..add('productId', productId)
          ..add('name', name)
          ..add('sellPrice', sellPrice)
          ..add('exportPrice', exportPrice)
          ..add('importPrice', importPrice))
        .toString();
  }
}

class CreateProductVariantRequestBuilder
    implements
        Builder<
          CreateProductVariantRequest,
          CreateProductVariantRequestBuilder
        > {
  _$CreateProductVariantRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  double? _exportPrice;
  double? get exportPrice => _$this._exportPrice;
  set exportPrice(double? exportPrice) => _$this._exportPrice = exportPrice;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  CreateProductVariantRequestBuilder() {
    CreateProductVariantRequest._defaults(this);
  }

  CreateProductVariantRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _name = $v.name;
      _sellPrice = $v.sellPrice;
      _exportPrice = $v.exportPrice;
      _importPrice = $v.importPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductVariantRequest other) {
    _$v = other as _$CreateProductVariantRequest;
  }

  @override
  void update(void Function(CreateProductVariantRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductVariantRequest build() => _build();

  _$CreateProductVariantRequest _build() {
    final _$result =
        _$v ??
        _$CreateProductVariantRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
            productId,
            r'CreateProductVariantRequest',
            'productId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CreateProductVariantRequest',
            'name',
          ),
          sellPrice: sellPrice,
          exportPrice: exportPrice,
          importPrice: importPrice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
