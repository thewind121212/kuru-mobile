// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductListPage {
  List<ProductSummary> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  num get maxSellPrice => throw _privateConstructorUsedError;

  /// Create a copy of ProductListPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductListPageCopyWith<ProductListPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductListPageCopyWith<$Res> {
  factory $ProductListPageCopyWith(
    ProductListPage value,
    $Res Function(ProductListPage) then,
  ) = _$ProductListPageCopyWithImpl<$Res, ProductListPage>;
  @useResult
  $Res call({
    List<ProductSummary> items,
    int page,
    int limit,
    int totalProducts,
    num maxSellPrice,
  });
}

/// @nodoc
class _$ProductListPageCopyWithImpl<$Res, $Val extends ProductListPage>
    implements $ProductListPageCopyWith<$Res> {
  _$ProductListPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductListPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? limit = null,
    Object? totalProducts = null,
    Object? maxSellPrice = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ProductSummary>,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            totalProducts: null == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                      as int,
            maxSellPrice: null == maxSellPrice
                ? _value.maxSellPrice
                : maxSellPrice // ignore: cast_nullable_to_non_nullable
                      as num,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductListPageImplCopyWith<$Res>
    implements $ProductListPageCopyWith<$Res> {
  factory _$$ProductListPageImplCopyWith(
    _$ProductListPageImpl value,
    $Res Function(_$ProductListPageImpl) then,
  ) = __$$ProductListPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ProductSummary> items,
    int page,
    int limit,
    int totalProducts,
    num maxSellPrice,
  });
}

/// @nodoc
class __$$ProductListPageImplCopyWithImpl<$Res>
    extends _$ProductListPageCopyWithImpl<$Res, _$ProductListPageImpl>
    implements _$$ProductListPageImplCopyWith<$Res> {
  __$$ProductListPageImplCopyWithImpl(
    _$ProductListPageImpl _value,
    $Res Function(_$ProductListPageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductListPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? limit = null,
    Object? totalProducts = null,
    Object? maxSellPrice = null,
  }) {
    return _then(
      _$ProductListPageImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ProductSummary>,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        totalProducts: null == totalProducts
            ? _value.totalProducts
            : totalProducts // ignore: cast_nullable_to_non_nullable
                  as int,
        maxSellPrice: null == maxSellPrice
            ? _value.maxSellPrice
            : maxSellPrice // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc

class _$ProductListPageImpl extends _ProductListPage {
  const _$ProductListPageImpl({
    required final List<ProductSummary> items,
    required this.page,
    required this.limit,
    required this.totalProducts,
    this.maxSellPrice = 0,
  }) : _items = items,
       super._();

  final List<ProductSummary> _items;
  @override
  List<ProductSummary> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalProducts;
  @override
  @JsonKey()
  final num maxSellPrice;

  @override
  String toString() {
    return 'ProductListPage(items: $items, page: $page, limit: $limit, totalProducts: $totalProducts, maxSellPrice: $maxSellPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductListPageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.maxSellPrice, maxSellPrice) ||
                other.maxSellPrice == maxSellPrice));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    page,
    limit,
    totalProducts,
    maxSellPrice,
  );

  /// Create a copy of ProductListPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductListPageImplCopyWith<_$ProductListPageImpl> get copyWith =>
      __$$ProductListPageImplCopyWithImpl<_$ProductListPageImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductListPage extends ProductListPage {
  const factory _ProductListPage({
    required final List<ProductSummary> items,
    required final int page,
    required final int limit,
    required final int totalProducts,
    final num maxSellPrice,
  }) = _$ProductListPageImpl;
  const _ProductListPage._() : super._();

  @override
  List<ProductSummary> get items;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalProducts;
  @override
  num get maxSellPrice;

  /// Create a copy of ProductListPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductListPageImplCopyWith<_$ProductListPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
