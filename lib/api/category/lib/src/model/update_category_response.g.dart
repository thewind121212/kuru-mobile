// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCategoryResponse extends UpdateCategoryResponse {
  @override
  final String? categoryId;

  factory _$UpdateCategoryResponse([
    void Function(UpdateCategoryResponseBuilder)? updates,
  ]) => (UpdateCategoryResponseBuilder()..update(updates))._build();

  _$UpdateCategoryResponse._({this.categoryId}) : super._();
  @override
  UpdateCategoryResponse rebuild(
    void Function(UpdateCategoryResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateCategoryResponseBuilder toBuilder() =>
      UpdateCategoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCategoryResponse && categoryId == other.categoryId;
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
      r'UpdateCategoryResponse',
    )..add('categoryId', categoryId)).toString();
  }
}

class UpdateCategoryResponseBuilder
    implements Builder<UpdateCategoryResponse, UpdateCategoryResponseBuilder> {
  _$UpdateCategoryResponse? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  UpdateCategoryResponseBuilder() {
    UpdateCategoryResponse._defaults(this);
  }

  UpdateCategoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCategoryResponse other) {
    _$v = other as _$UpdateCategoryResponse;
  }

  @override
  void update(void Function(UpdateCategoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCategoryResponse build() => _build();

  _$UpdateCategoryResponse _build() {
    final _$result = _$v ?? _$UpdateCategoryResponse._(categoryId: categoryId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
