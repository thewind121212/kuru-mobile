// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductListFilter {
  String? get search => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get brandId => throw _privateConstructorUsedError;

  /// Create a copy of ProductListFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductListFilterCopyWith<ProductListFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductListFilterCopyWith<$Res> {
  factory $ProductListFilterCopyWith(
    ProductListFilter value,
    $Res Function(ProductListFilter) then,
  ) = _$ProductListFilterCopyWithImpl<$Res, ProductListFilter>;
  @useResult
  $Res call({String? search, String? categoryId, String? brandId});
}

/// @nodoc
class _$ProductListFilterCopyWithImpl<$Res, $Val extends ProductListFilter>
    implements $ProductListFilterCopyWith<$Res> {
  _$ProductListFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductListFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? categoryId = freezed,
    Object? brandId = freezed,
  }) {
    return _then(
      _value.copyWith(
            search: freezed == search
                ? _value.search
                : search // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandId: freezed == brandId
                ? _value.brandId
                : brandId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductListFilterImplCopyWith<$Res>
    implements $ProductListFilterCopyWith<$Res> {
  factory _$$ProductListFilterImplCopyWith(
    _$ProductListFilterImpl value,
    $Res Function(_$ProductListFilterImpl) then,
  ) = __$$ProductListFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? search, String? categoryId, String? brandId});
}

/// @nodoc
class __$$ProductListFilterImplCopyWithImpl<$Res>
    extends _$ProductListFilterCopyWithImpl<$Res, _$ProductListFilterImpl>
    implements _$$ProductListFilterImplCopyWith<$Res> {
  __$$ProductListFilterImplCopyWithImpl(
    _$ProductListFilterImpl _value,
    $Res Function(_$ProductListFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductListFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? categoryId = freezed,
    Object? brandId = freezed,
  }) {
    return _then(
      _$ProductListFilterImpl(
        search: freezed == search
            ? _value.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandId: freezed == brandId
            ? _value.brandId
            : brandId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ProductListFilterImpl implements _ProductListFilter {
  const _$ProductListFilterImpl({this.search, this.categoryId, this.brandId});

  @override
  final String? search;
  @override
  final String? categoryId;
  @override
  final String? brandId;

  @override
  String toString() {
    return 'ProductListFilter(search: $search, categoryId: $categoryId, brandId: $brandId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductListFilterImpl &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, search, categoryId, brandId);

  /// Create a copy of ProductListFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductListFilterImplCopyWith<_$ProductListFilterImpl> get copyWith =>
      __$$ProductListFilterImplCopyWithImpl<_$ProductListFilterImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductListFilter implements ProductListFilter {
  const factory _ProductListFilter({
    final String? search,
    final String? categoryId,
    final String? brandId,
  }) = _$ProductListFilterImpl;

  @override
  String? get search;
  @override
  String? get categoryId;
  @override
  String? get brandId;

  /// Create a copy of ProductListFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductListFilterImplCopyWith<_$ProductListFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
