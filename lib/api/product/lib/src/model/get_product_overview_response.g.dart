// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_overview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductOverviewResponse extends GetProductOverviewResponse {
  @override
  final BuiltList<ProductOverviewResponse>? products;
  @override
  final double maxSellPrice;
  @override
  final int totalProducts;
  @override
  final double totalValue;
  @override
  final int totalVariants;

  factory _$GetProductOverviewResponse([
    void Function(GetProductOverviewResponseBuilder)? updates,
  ]) => (GetProductOverviewResponseBuilder()..update(updates))._build();

  _$GetProductOverviewResponse._({
    this.products,
    required this.maxSellPrice,
    required this.totalProducts,
    required this.totalValue,
    required this.totalVariants,
  }) : super._();
  @override
  GetProductOverviewResponse rebuild(
    void Function(GetProductOverviewResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductOverviewResponseBuilder toBuilder() =>
      GetProductOverviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductOverviewResponse &&
        products == other.products &&
        maxSellPrice == other.maxSellPrice &&
        totalProducts == other.totalProducts &&
        totalValue == other.totalValue &&
        totalVariants == other.totalVariants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jc(_$hash, maxSellPrice.hashCode);
    _$hash = $jc(_$hash, totalProducts.hashCode);
    _$hash = $jc(_$hash, totalValue.hashCode);
    _$hash = $jc(_$hash, totalVariants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetProductOverviewResponse')
          ..add('products', products)
          ..add('maxSellPrice', maxSellPrice)
          ..add('totalProducts', totalProducts)
          ..add('totalValue', totalValue)
          ..add('totalVariants', totalVariants))
        .toString();
  }
}

class GetProductOverviewResponseBuilder
    implements
        Builder<GetProductOverviewResponse, GetProductOverviewResponseBuilder> {
  _$GetProductOverviewResponse? _$v;

  ListBuilder<ProductOverviewResponse>? _products;
  ListBuilder<ProductOverviewResponse> get products =>
      _$this._products ??= ListBuilder<ProductOverviewResponse>();
  set products(ListBuilder<ProductOverviewResponse>? products) =>
      _$this._products = products;

  double? _maxSellPrice;
  double? get maxSellPrice => _$this._maxSellPrice;
  set maxSellPrice(double? maxSellPrice) => _$this._maxSellPrice = maxSellPrice;

  int? _totalProducts;
  int? get totalProducts => _$this._totalProducts;
  set totalProducts(int? totalProducts) =>
      _$this._totalProducts = totalProducts;

  double? _totalValue;
  double? get totalValue => _$this._totalValue;
  set totalValue(double? totalValue) => _$this._totalValue = totalValue;

  int? _totalVariants;
  int? get totalVariants => _$this._totalVariants;
  set totalVariants(int? totalVariants) =>
      _$this._totalVariants = totalVariants;

  GetProductOverviewResponseBuilder() {
    GetProductOverviewResponse._defaults(this);
  }

  GetProductOverviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _products = $v.products?.toBuilder();
      _maxSellPrice = $v.maxSellPrice;
      _totalProducts = $v.totalProducts;
      _totalValue = $v.totalValue;
      _totalVariants = $v.totalVariants;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProductOverviewResponse other) {
    _$v = other as _$GetProductOverviewResponse;
  }

  @override
  void update(void Function(GetProductOverviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductOverviewResponse build() => _build();

  _$GetProductOverviewResponse _build() {
    _$GetProductOverviewResponse _$result;
    try {
      _$result =
          _$v ??
          _$GetProductOverviewResponse._(
            products: _products?.build(),
            maxSellPrice: BuiltValueNullFieldError.checkNotNull(
              maxSellPrice,
              r'GetProductOverviewResponse',
              'maxSellPrice',
            ),
            totalProducts: BuiltValueNullFieldError.checkNotNull(
              totalProducts,
              r'GetProductOverviewResponse',
              'totalProducts',
            ),
            totalValue: BuiltValueNullFieldError.checkNotNull(
              totalValue,
              r'GetProductOverviewResponse',
              'totalValue',
            ),
            totalVariants: BuiltValueNullFieldError.checkNotNull(
              totalVariants,
              r'GetProductOverviewResponse',
              'totalVariants',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'products';
        _products?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetProductOverviewResponse',
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
