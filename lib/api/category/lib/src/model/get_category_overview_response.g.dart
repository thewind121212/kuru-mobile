// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_overview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryOverviewResponse extends GetCategoryOverviewResponse {
  @override
  final BuiltList<CategoryResponse>? categoryOverviews;

  factory _$GetCategoryOverviewResponse(
          [void Function(GetCategoryOverviewResponseBuilder)? updates]) =>
      (GetCategoryOverviewResponseBuilder()..update(updates))._build();

  _$GetCategoryOverviewResponse._({this.categoryOverviews}) : super._();
  @override
  GetCategoryOverviewResponse rebuild(
          void Function(GetCategoryOverviewResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryOverviewResponseBuilder toBuilder() =>
      GetCategoryOverviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryOverviewResponse &&
        categoryOverviews == other.categoryOverviews;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryOverviews.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetCategoryOverviewResponse')
          ..add('categoryOverviews', categoryOverviews))
        .toString();
  }
}

class GetCategoryOverviewResponseBuilder
    implements
        Builder<GetCategoryOverviewResponse,
            GetCategoryOverviewResponseBuilder> {
  _$GetCategoryOverviewResponse? _$v;

  ListBuilder<CategoryResponse>? _categoryOverviews;
  ListBuilder<CategoryResponse> get categoryOverviews =>
      _$this._categoryOverviews ??= ListBuilder<CategoryResponse>();
  set categoryOverviews(ListBuilder<CategoryResponse>? categoryOverviews) =>
      _$this._categoryOverviews = categoryOverviews;

  GetCategoryOverviewResponseBuilder() {
    GetCategoryOverviewResponse._defaults(this);
  }

  GetCategoryOverviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryOverviews = $v.categoryOverviews?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCategoryOverviewResponse other) {
    _$v = other as _$GetCategoryOverviewResponse;
  }

  @override
  void update(void Function(GetCategoryOverviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryOverviewResponse build() => _build();

  _$GetCategoryOverviewResponse _build() {
    _$GetCategoryOverviewResponse _$result;
    try {
      _$result = _$v ??
          _$GetCategoryOverviewResponse._(
            categoryOverviews: _categoryOverviews?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryOverviews';
        _categoryOverviews?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCategoryOverviewResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
