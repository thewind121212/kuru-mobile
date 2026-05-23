// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_overview_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderOverviewPage {
  List<OrderSummary> get orders => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Create a copy of OrderOverviewPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderOverviewPageCopyWith<OrderOverviewPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderOverviewPageCopyWith<$Res> {
  factory $OrderOverviewPageCopyWith(
    OrderOverviewPage value,
    $Res Function(OrderOverviewPage) then,
  ) = _$OrderOverviewPageCopyWithImpl<$Res, OrderOverviewPage>;
  @useResult
  $Res call({List<OrderSummary> orders, int total, int page, int limit});
}

/// @nodoc
class _$OrderOverviewPageCopyWithImpl<$Res, $Val extends OrderOverviewPage>
    implements $OrderOverviewPageCopyWith<$Res> {
  _$OrderOverviewPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderOverviewPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            orders: null == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as List<OrderSummary>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderOverviewPageImplCopyWith<$Res>
    implements $OrderOverviewPageCopyWith<$Res> {
  factory _$$OrderOverviewPageImplCopyWith(
    _$OrderOverviewPageImpl value,
    $Res Function(_$OrderOverviewPageImpl) then,
  ) = __$$OrderOverviewPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OrderSummary> orders, int total, int page, int limit});
}

/// @nodoc
class __$$OrderOverviewPageImplCopyWithImpl<$Res>
    extends _$OrderOverviewPageCopyWithImpl<$Res, _$OrderOverviewPageImpl>
    implements _$$OrderOverviewPageImplCopyWith<$Res> {
  __$$OrderOverviewPageImplCopyWithImpl(
    _$OrderOverviewPageImpl _value,
    $Res Function(_$OrderOverviewPageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderOverviewPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _$OrderOverviewPageImpl(
        orders: null == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<OrderSummary>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OrderOverviewPageImpl extends _OrderOverviewPage {
  const _$OrderOverviewPageImpl({
    required final List<OrderSummary> orders,
    required this.total,
    required this.page,
    required this.limit,
  }) : _orders = orders,
       super._();

  final List<OrderSummary> _orders;
  @override
  List<OrderSummary> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;

  @override
  String toString() {
    return 'OrderOverviewPage(orders: $orders, total: $total, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderOverviewPageImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_orders),
    total,
    page,
    limit,
  );

  /// Create a copy of OrderOverviewPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderOverviewPageImplCopyWith<_$OrderOverviewPageImpl> get copyWith =>
      __$$OrderOverviewPageImplCopyWithImpl<_$OrderOverviewPageImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderOverviewPage extends OrderOverviewPage {
  const factory _OrderOverviewPage({
    required final List<OrderSummary> orders,
    required final int total,
    required final int page,
    required final int limit,
  }) = _$OrderOverviewPageImpl;
  const _OrderOverviewPage._() : super._();

  @override
  List<OrderSummary> get orders;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;

  /// Create a copy of OrderOverviewPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderOverviewPageImplCopyWith<_$OrderOverviewPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
