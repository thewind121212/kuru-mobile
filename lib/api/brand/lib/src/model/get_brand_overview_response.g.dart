// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_overview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetBrandOverviewResponse extends GetBrandOverviewResponse {
  @override
  final BuiltList<BrandOverviewItem>? brands;
  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;

  factory _$GetBrandOverviewResponse([
    void Function(GetBrandOverviewResponseBuilder)? updates,
  ]) => (GetBrandOverviewResponseBuilder()..update(updates))._build();

  _$GetBrandOverviewResponse._({
    this.brands,
    required this.total,
    required this.page,
    required this.limit,
  }) : super._();
  @override
  GetBrandOverviewResponse rebuild(
    void Function(GetBrandOverviewResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetBrandOverviewResponseBuilder toBuilder() =>
      GetBrandOverviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetBrandOverviewResponse &&
        brands == other.brands &&
        total == other.total &&
        page == other.page &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brands.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetBrandOverviewResponse')
          ..add('brands', brands)
          ..add('total', total)
          ..add('page', page)
          ..add('limit', limit))
        .toString();
  }
}

class GetBrandOverviewResponseBuilder
    implements
        Builder<GetBrandOverviewResponse, GetBrandOverviewResponseBuilder> {
  _$GetBrandOverviewResponse? _$v;

  ListBuilder<BrandOverviewItem>? _brands;
  ListBuilder<BrandOverviewItem> get brands =>
      _$this._brands ??= ListBuilder<BrandOverviewItem>();
  set brands(ListBuilder<BrandOverviewItem>? brands) => _$this._brands = brands;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  GetBrandOverviewResponseBuilder() {
    GetBrandOverviewResponse._defaults(this);
  }

  GetBrandOverviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brands = $v.brands?.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetBrandOverviewResponse other) {
    _$v = other as _$GetBrandOverviewResponse;
  }

  @override
  void update(void Function(GetBrandOverviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetBrandOverviewResponse build() => _build();

  _$GetBrandOverviewResponse _build() {
    _$GetBrandOverviewResponse _$result;
    try {
      _$result =
          _$v ??
          _$GetBrandOverviewResponse._(
            brands: _brands?.build(),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'GetBrandOverviewResponse',
              'total',
            ),
            page: BuiltValueNullFieldError.checkNotNull(
              page,
              r'GetBrandOverviewResponse',
              'page',
            ),
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'GetBrandOverviewResponse',
              'limit',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'brands';
        _brands?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetBrandOverviewResponse',
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
