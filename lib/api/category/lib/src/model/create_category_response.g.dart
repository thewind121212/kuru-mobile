// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCategoryResponse extends CreateCategoryResponse {
  @override
  final String? categoryId;

  factory _$CreateCategoryResponse([
    void Function(CreateCategoryResponseBuilder)? updates,
  ]) => (CreateCategoryResponseBuilder()..update(updates))._build();

  _$CreateCategoryResponse._({this.categoryId}) : super._();
  @override
  CreateCategoryResponse rebuild(
    void Function(CreateCategoryResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateCategoryResponseBuilder toBuilder() =>
      CreateCategoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCategoryResponse && categoryId == other.categoryId;
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
      r'CreateCategoryResponse',
    )..add('categoryId', categoryId)).toString();
  }
}

class CreateCategoryResponseBuilder
    implements Builder<CreateCategoryResponse, CreateCategoryResponseBuilder> {
  _$CreateCategoryResponse? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  CreateCategoryResponseBuilder() {
    CreateCategoryResponse._defaults(this);
  }

  CreateCategoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCategoryResponse other) {
    _$v = other as _$CreateCategoryResponse;
  }

  @override
  void update(void Function(CreateCategoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCategoryResponse build() => _build();

  _$CreateCategoryResponse _build() {
    final _$result = _$v ?? _$CreateCategoryResponse._(categoryId: categoryId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
