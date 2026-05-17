// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_by_id_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryByIdRequest extends GetCategoryByIdRequest {
  @override
  final String categoryId;

  factory _$GetCategoryByIdRequest([
    void Function(GetCategoryByIdRequestBuilder)? updates,
  ]) => (GetCategoryByIdRequestBuilder()..update(updates))._build();

  _$GetCategoryByIdRequest._({required this.categoryId}) : super._();
  @override
  GetCategoryByIdRequest rebuild(
    void Function(GetCategoryByIdRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetCategoryByIdRequestBuilder toBuilder() =>
      GetCategoryByIdRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryByIdRequest && categoryId == other.categoryId;
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
      r'GetCategoryByIdRequest',
    )..add('categoryId', categoryId)).toString();
  }
}

class GetCategoryByIdRequestBuilder
    implements Builder<GetCategoryByIdRequest, GetCategoryByIdRequestBuilder> {
  _$GetCategoryByIdRequest? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  GetCategoryByIdRequestBuilder() {
    GetCategoryByIdRequest._defaults(this);
  }

  GetCategoryByIdRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCategoryByIdRequest other) {
    _$v = other as _$GetCategoryByIdRequest;
  }

  @override
  void update(void Function(GetCategoryByIdRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryByIdRequest build() => _build();

  _$GetCategoryByIdRequest _build() {
    final _$result =
        _$v ??
        _$GetCategoryByIdRequest._(
          categoryId: BuiltValueNullFieldError.checkNotNull(
            categoryId,
            r'GetCategoryByIdRequest',
            'categoryId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
