// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_category_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemoveCategoryResponse extends RemoveCategoryResponse {
  @override
  final int removedCount;

  factory _$RemoveCategoryResponse([
    void Function(RemoveCategoryResponseBuilder)? updates,
  ]) => (RemoveCategoryResponseBuilder()..update(updates))._build();

  _$RemoveCategoryResponse._({required this.removedCount}) : super._();
  @override
  RemoveCategoryResponse rebuild(
    void Function(RemoveCategoryResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RemoveCategoryResponseBuilder toBuilder() =>
      RemoveCategoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemoveCategoryResponse &&
        removedCount == other.removedCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, removedCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RemoveCategoryResponse',
    )..add('removedCount', removedCount)).toString();
  }
}

class RemoveCategoryResponseBuilder
    implements Builder<RemoveCategoryResponse, RemoveCategoryResponseBuilder> {
  _$RemoveCategoryResponse? _$v;

  int? _removedCount;
  int? get removedCount => _$this._removedCount;
  set removedCount(int? removedCount) => _$this._removedCount = removedCount;

  RemoveCategoryResponseBuilder() {
    RemoveCategoryResponse._defaults(this);
  }

  RemoveCategoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _removedCount = $v.removedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemoveCategoryResponse other) {
    _$v = other as _$RemoveCategoryResponse;
  }

  @override
  void update(void Function(RemoveCategoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemoveCategoryResponse build() => _build();

  _$RemoveCategoryResponse _build() {
    final _$result =
        _$v ??
        _$RemoveCategoryResponse._(
          removedCount: BuiltValueNullFieldError.checkNotNull(
            removedCount,
            r'RemoveCategoryResponse',
            'removedCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
