// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_tree_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryTreeRequest extends GetCategoryTreeRequest {
  @override
  final String categoryId;

  factory _$GetCategoryTreeRequest([
    void Function(GetCategoryTreeRequestBuilder)? updates,
  ]) => (GetCategoryTreeRequestBuilder()..update(updates))._build();

  _$GetCategoryTreeRequest._({required this.categoryId}) : super._();
  @override
  GetCategoryTreeRequest rebuild(
    void Function(GetCategoryTreeRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetCategoryTreeRequestBuilder toBuilder() =>
      GetCategoryTreeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryTreeRequest && categoryId == other.categoryId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GetCategoryTreeRequest',
    )..add('categoryId', categoryId)).toString();
  }
}

class GetCategoryTreeRequestBuilder
    implements Builder<GetCategoryTreeRequest, GetCategoryTreeRequestBuilder> {
  _$GetCategoryTreeRequest? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  GetCategoryTreeRequestBuilder() {
    GetCategoryTreeRequest._defaults(this);
  }

  GetCategoryTreeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCategoryTreeRequest other) {
    _$v = other as _$GetCategoryTreeRequest;
  }

  @override
  void update(void Function(GetCategoryTreeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryTreeRequest build() => _build();

  _$GetCategoryTreeRequest _build() {
    final _$result =
        _$v ??
        _$GetCategoryTreeRequest._(
          categoryId: BuiltValueNullFieldError.checkNotNull(
            categoryId,
            r'GetCategoryTreeRequest',
            'categoryId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
