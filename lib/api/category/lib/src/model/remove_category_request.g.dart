// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_category_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemoveCategoryRequest extends RemoveCategoryRequest {
  @override
  final BuiltList<String>? categoryIds;

  factory _$RemoveCategoryRequest(
          [void Function(RemoveCategoryRequestBuilder)? updates]) =>
      (RemoveCategoryRequestBuilder()..update(updates))._build();

  _$RemoveCategoryRequest._({this.categoryIds}) : super._();
  @override
  RemoveCategoryRequest rebuild(
          void Function(RemoveCategoryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemoveCategoryRequestBuilder toBuilder() =>
      RemoveCategoryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemoveCategoryRequest && categoryIds == other.categoryIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RemoveCategoryRequest')
          ..add('categoryIds', categoryIds))
        .toString();
  }
}

class RemoveCategoryRequestBuilder
    implements Builder<RemoveCategoryRequest, RemoveCategoryRequestBuilder> {
  _$RemoveCategoryRequest? _$v;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  RemoveCategoryRequestBuilder() {
    RemoveCategoryRequest._defaults(this);
  }

  RemoveCategoryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryIds = $v.categoryIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemoveCategoryRequest other) {
    _$v = other as _$RemoveCategoryRequest;
  }

  @override
  void update(void Function(RemoveCategoryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemoveCategoryRequest build() => _build();

  _$RemoveCategoryRequest _build() {
    _$RemoveCategoryRequest _$result;
    try {
      _$result = _$v ??
          _$RemoveCategoryRequest._(
            categoryIds: _categoryIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        _categoryIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RemoveCategoryRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
