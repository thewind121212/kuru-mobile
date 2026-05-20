// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_overview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductOverviewRequest extends GetProductOverviewRequest {
  @override
  final String? searchString;
  @override
  final BuiltList<String>? categoryIds;
  @override
  final BuiltList<String>? distributorIds;
  @override
  final int? page;
  @override
  final int? limit;
  @override
  final BuiltList<String>? warehouseIds;
  @override
  final BuiltList<String>? attributeFilters;
  @override
  final double? minPrice;
  @override
  final double? maxPrice;
  @override
  final BuiltList<String>? brandIds;

  factory _$GetProductOverviewRequest([
    void Function(GetProductOverviewRequestBuilder)? updates,
  ]) => (GetProductOverviewRequestBuilder()..update(updates))._build();

  _$GetProductOverviewRequest._({
    this.searchString,
    this.categoryIds,
    this.distributorIds,
    this.page,
    this.limit,
    this.warehouseIds,
    this.attributeFilters,
    this.minPrice,
    this.maxPrice,
    this.brandIds,
  }) : super._();
  @override
  GetProductOverviewRequest rebuild(
    void Function(GetProductOverviewRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductOverviewRequestBuilder toBuilder() =>
      GetProductOverviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductOverviewRequest &&
        searchString == other.searchString &&
        categoryIds == other.categoryIds &&
        distributorIds == other.distributorIds &&
        page == other.page &&
        limit == other.limit &&
        warehouseIds == other.warehouseIds &&
        attributeFilters == other.attributeFilters &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        brandIds == other.brandIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, searchString.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, distributorIds.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, warehouseIds.hashCode);
    _$hash = $jc(_$hash, attributeFilters.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, maxPrice.hashCode);
    _$hash = $jc(_$hash, brandIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetProductOverviewRequest')
          ..add('searchString', searchString)
          ..add('categoryIds', categoryIds)
          ..add('distributorIds', distributorIds)
          ..add('page', page)
          ..add('limit', limit)
          ..add('warehouseIds', warehouseIds)
          ..add('attributeFilters', attributeFilters)
          ..add('minPrice', minPrice)
          ..add('maxPrice', maxPrice)
          ..add('brandIds', brandIds))
        .toString();
  }
}

class GetProductOverviewRequestBuilder
    implements
        Builder<GetProductOverviewRequest, GetProductOverviewRequestBuilder> {
  _$GetProductOverviewRequest? _$v;

  String? _searchString;
  String? get searchString => _$this._searchString;
  set searchString(String? searchString) => _$this._searchString = searchString;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  ListBuilder<String>? _distributorIds;
  ListBuilder<String> get distributorIds =>
      _$this._distributorIds ??= ListBuilder<String>();
  set distributorIds(ListBuilder<String>? distributorIds) =>
      _$this._distributorIds = distributorIds;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  ListBuilder<String>? _warehouseIds;
  ListBuilder<String> get warehouseIds =>
      _$this._warehouseIds ??= ListBuilder<String>();
  set warehouseIds(ListBuilder<String>? warehouseIds) =>
      _$this._warehouseIds = warehouseIds;

  ListBuilder<String>? _attributeFilters;
  ListBuilder<String> get attributeFilters =>
      _$this._attributeFilters ??= ListBuilder<String>();
  set attributeFilters(ListBuilder<String>? attributeFilters) =>
      _$this._attributeFilters = attributeFilters;

  double? _minPrice;
  double? get minPrice => _$this._minPrice;
  set minPrice(double? minPrice) => _$this._minPrice = minPrice;

  double? _maxPrice;
  double? get maxPrice => _$this._maxPrice;
  set maxPrice(double? maxPrice) => _$this._maxPrice = maxPrice;

  ListBuilder<String>? _brandIds;
  ListBuilder<String> get brandIds =>
      _$this._brandIds ??= ListBuilder<String>();
  set brandIds(ListBuilder<String>? brandIds) => _$this._brandIds = brandIds;

  GetProductOverviewRequestBuilder() {
    GetProductOverviewRequest._defaults(this);
  }

  GetProductOverviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchString = $v.searchString;
      _categoryIds = $v.categoryIds?.toBuilder();
      _distributorIds = $v.distributorIds?.toBuilder();
      _page = $v.page;
      _limit = $v.limit;
      _warehouseIds = $v.warehouseIds?.toBuilder();
      _attributeFilters = $v.attributeFilters?.toBuilder();
      _minPrice = $v.minPrice;
      _maxPrice = $v.maxPrice;
      _brandIds = $v.brandIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProductOverviewRequest other) {
    _$v = other as _$GetProductOverviewRequest;
  }

  @override
  void update(void Function(GetProductOverviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductOverviewRequest build() => _build();

  _$GetProductOverviewRequest _build() {
    _$GetProductOverviewRequest _$result;
    try {
      _$result =
          _$v ??
          _$GetProductOverviewRequest._(
            searchString: searchString,
            categoryIds: _categoryIds?.build(),
            distributorIds: _distributorIds?.build(),
            page: page,
            limit: limit,
            warehouseIds: _warehouseIds?.build(),
            attributeFilters: _attributeFilters?.build(),
            minPrice: minPrice,
            maxPrice: maxPrice,
            brandIds: _brandIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        _categoryIds?.build();
        _$failedField = 'distributorIds';
        _distributorIds?.build();

        _$failedField = 'warehouseIds';
        _warehouseIds?.build();
        _$failedField = 'attributeFilters';
        _attributeFilters?.build();

        _$failedField = 'brandIds';
        _brandIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetProductOverviewRequest',
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
