// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCategoryRequest extends UpdateCategoryRequest {
  @override
  final String categoryId;
  @override
  final CreateCategoryRequest categoryUpdate;

  factory _$UpdateCategoryRequest(
          [void Function(UpdateCategoryRequestBuilder)? updates]) =>
      (UpdateCategoryRequestBuilder()..update(updates))._build();

  _$UpdateCategoryRequest._(
      {required this.categoryId, required this.categoryUpdate})
      : super._();
  @override
  UpdateCategoryRequest rebuild(
          void Function(UpdateCategoryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCategoryRequestBuilder toBuilder() =>
      UpdateCategoryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCategoryRequest &&
        categoryId == other.categoryId &&
        categoryUpdate == other.categoryUpdate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryUpdate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCategoryRequest')
          ..add('categoryId', categoryId)
          ..add('categoryUpdate', categoryUpdate))
        .toString();
  }
}

class UpdateCategoryRequestBuilder
    implements Builder<UpdateCategoryRequest, UpdateCategoryRequestBuilder> {
  _$UpdateCategoryRequest? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  CreateCategoryRequestBuilder? _categoryUpdate;
  CreateCategoryRequestBuilder get categoryUpdate =>
      _$this._categoryUpdate ??= CreateCategoryRequestBuilder();
  set categoryUpdate(CreateCategoryRequestBuilder? categoryUpdate) =>
      _$this._categoryUpdate = categoryUpdate;

  UpdateCategoryRequestBuilder() {
    UpdateCategoryRequest._defaults(this);
  }

  UpdateCategoryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _categoryUpdate = $v.categoryUpdate.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCategoryRequest other) {
    _$v = other as _$UpdateCategoryRequest;
  }

  @override
  void update(void Function(UpdateCategoryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCategoryRequest build() => _build();

  _$UpdateCategoryRequest _build() {
    _$UpdateCategoryRequest _$result;
    try {
      _$result = _$v ??
          _$UpdateCategoryRequest._(
            categoryId: BuiltValueNullFieldError.checkNotNull(
                categoryId, r'UpdateCategoryRequest', 'categoryId'),
            categoryUpdate: categoryUpdate.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryUpdate';
        categoryUpdate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateCategoryRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
