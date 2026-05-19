// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_overview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetBrandOverviewRequest extends GetBrandOverviewRequest {
  @override
  final String? searchString;
  @override
  final int? page;
  @override
  final int? limit;

  factory _$GetBrandOverviewRequest([
    void Function(GetBrandOverviewRequestBuilder)? updates,
  ]) => (GetBrandOverviewRequestBuilder()..update(updates))._build();

  _$GetBrandOverviewRequest._({this.searchString, this.page, this.limit})
    : super._();
  @override
  GetBrandOverviewRequest rebuild(
    void Function(GetBrandOverviewRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetBrandOverviewRequestBuilder toBuilder() =>
      GetBrandOverviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetBrandOverviewRequest &&
        searchString == other.searchString &&
        page == other.page &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, searchString.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetBrandOverviewRequest')
          ..add('searchString', searchString)
          ..add('page', page)
          ..add('limit', limit))
        .toString();
  }
}

class GetBrandOverviewRequestBuilder
    implements
        Builder<GetBrandOverviewRequest, GetBrandOverviewRequestBuilder> {
  _$GetBrandOverviewRequest? _$v;

  String? _searchString;
  String? get searchString => _$this._searchString;
  set searchString(String? searchString) => _$this._searchString = searchString;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  GetBrandOverviewRequestBuilder() {
    GetBrandOverviewRequest._defaults(this);
  }

  GetBrandOverviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchString = $v.searchString;
      _page = $v.page;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetBrandOverviewRequest other) {
    _$v = other as _$GetBrandOverviewRequest;
  }

  @override
  void update(void Function(GetBrandOverviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetBrandOverviewRequest build() => _build();

  _$GetBrandOverviewRequest _build() {
    final _$result =
        _$v ??
        _$GetBrandOverviewRequest._(
          searchString: searchString,
          page: page,
          limit: limit,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
