// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_overview_with_depth_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryOverviewWithDepthRequest
    extends GetCategoryOverviewWithDepthRequest {
  @override
  final int depth;

  factory _$GetCategoryOverviewWithDepthRequest(
          [void Function(GetCategoryOverviewWithDepthRequestBuilder)?
              updates]) =>
      (GetCategoryOverviewWithDepthRequestBuilder()..update(updates))._build();

  _$GetCategoryOverviewWithDepthRequest._({required this.depth}) : super._();
  @override
  GetCategoryOverviewWithDepthRequest rebuild(
          void Function(GetCategoryOverviewWithDepthRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryOverviewWithDepthRequestBuilder toBuilder() =>
      GetCategoryOverviewWithDepthRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryOverviewWithDepthRequest && depth == other.depth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, depth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetCategoryOverviewWithDepthRequest')
          ..add('depth', depth))
        .toString();
  }
}

class GetCategoryOverviewWithDepthRequestBuilder
    implements
        Builder<GetCategoryOverviewWithDepthRequest,
            GetCategoryOverviewWithDepthRequestBuilder> {
  _$GetCategoryOverviewWithDepthRequest? _$v;

  int? _depth;
  int? get depth => _$this._depth;
  set depth(int? depth) => _$this._depth = depth;

  GetCategoryOverviewWithDepthRequestBuilder() {
    GetCategoryOverviewWithDepthRequest._defaults(this);
  }

  GetCategoryOverviewWithDepthRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _depth = $v.depth;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCategoryOverviewWithDepthRequest other) {
    _$v = other as _$GetCategoryOverviewWithDepthRequest;
  }

  @override
  void update(
      void Function(GetCategoryOverviewWithDepthRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryOverviewWithDepthRequest build() => _build();

  _$GetCategoryOverviewWithDepthRequest _build() {
    final _$result = _$v ??
        _$GetCategoryOverviewWithDepthRequest._(
          depth: BuiltValueNullFieldError.checkNotNull(
              depth, r'GetCategoryOverviewWithDepthRequest', 'depth'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
