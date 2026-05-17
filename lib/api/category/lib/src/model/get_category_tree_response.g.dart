// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_tree_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryTreeResponse extends GetCategoryTreeResponse {
  @override
  final BuiltList<CategoryResponse>? categoryTree;

  factory _$GetCategoryTreeResponse(
          [void Function(GetCategoryTreeResponseBuilder)? updates]) =>
      (GetCategoryTreeResponseBuilder()..update(updates))._build();

  _$GetCategoryTreeResponse._({this.categoryTree}) : super._();
  @override
  GetCategoryTreeResponse rebuild(
          void Function(GetCategoryTreeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryTreeResponseBuilder toBuilder() =>
      GetCategoryTreeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryTreeResponse &&
        categoryTree == other.categoryTree;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryTree.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetCategoryTreeResponse')
          ..add('categoryTree', categoryTree))
        .toString();
  }
}

class GetCategoryTreeResponseBuilder
    implements
        Builder<GetCategoryTreeResponse, GetCategoryTreeResponseBuilder> {
  _$GetCategoryTreeResponse? _$v;

  ListBuilder<CategoryResponse>? _categoryTree;
  ListBuilder<CategoryResponse> get categoryTree =>
      _$this._categoryTree ??= ListBuilder<CategoryResponse>();
  set categoryTree(ListBuilder<CategoryResponse>? categoryTree) =>
      _$this._categoryTree = categoryTree;

  GetCategoryTreeResponseBuilder() {
    GetCategoryTreeResponse._defaults(this);
  }

  GetCategoryTreeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryTree = $v.categoryTree?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCategoryTreeResponse other) {
    _$v = other as _$GetCategoryTreeResponse;
  }

  @override
  void update(void Function(GetCategoryTreeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryTreeResponse build() => _build();

  _$GetCategoryTreeResponse _build() {
    _$GetCategoryTreeResponse _$result;
    try {
      _$result = _$v ??
          _$GetCategoryTreeResponse._(
            categoryTree: _categoryTree?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryTree';
        _categoryTree?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCategoryTreeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
