// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_list_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderListFilters {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  OrderStatus? get status => throw _privateConstructorUsedError;
  OrderPaymentStatus? get paymentStatus => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;
  OrderSaleChannel? get saleChannel => throw _privateConstructorUsedError;

  /// Create a copy of OrderListFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderListFiltersCopyWith<OrderListFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderListFiltersCopyWith<$Res> {
  factory $OrderListFiltersCopyWith(
    OrderListFilters value,
    $Res Function(OrderListFilters) then,
  ) = _$OrderListFiltersCopyWithImpl<$Res, OrderListFilters>;
  @useResult
  $Res call({
    int page,
    int limit,
    String? search,
    OrderStatus? status,
    OrderPaymentStatus? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    OrderSaleChannel? saleChannel,
  });
}

/// @nodoc
class _$OrderListFiltersCopyWithImpl<$Res, $Val extends OrderListFilters>
    implements $OrderListFiltersCopyWith<$Res> {
  _$OrderListFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderListFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? search = freezed,
    Object? status = freezed,
    Object? paymentStatus = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? saleChannel = freezed,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            search: freezed == search
                ? _value.search
                : search // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus?,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentStatus?,
            fromDate: freezed == fromDate
                ? _value.fromDate
                : fromDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            toDate: freezed == toDate
                ? _value.toDate
                : toDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            saleChannel: freezed == saleChannel
                ? _value.saleChannel
                : saleChannel // ignore: cast_nullable_to_non_nullable
                      as OrderSaleChannel?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderListFiltersImplCopyWith<$Res>
    implements $OrderListFiltersCopyWith<$Res> {
  factory _$$OrderListFiltersImplCopyWith(
    _$OrderListFiltersImpl value,
    $Res Function(_$OrderListFiltersImpl) then,
  ) = __$$OrderListFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    int limit,
    String? search,
    OrderStatus? status,
    OrderPaymentStatus? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    OrderSaleChannel? saleChannel,
  });
}

/// @nodoc
class __$$OrderListFiltersImplCopyWithImpl<$Res>
    extends _$OrderListFiltersCopyWithImpl<$Res, _$OrderListFiltersImpl>
    implements _$$OrderListFiltersImplCopyWith<$Res> {
  __$$OrderListFiltersImplCopyWithImpl(
    _$OrderListFiltersImpl _value,
    $Res Function(_$OrderListFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderListFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? search = freezed,
    Object? status = freezed,
    Object? paymentStatus = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? saleChannel = freezed,
  }) {
    return _then(
      _$OrderListFiltersImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        search: freezed == search
            ? _value.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus?,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentStatus?,
        fromDate: freezed == fromDate
            ? _value.fromDate
            : fromDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        toDate: freezed == toDate
            ? _value.toDate
            : toDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        saleChannel: freezed == saleChannel
            ? _value.saleChannel
            : saleChannel // ignore: cast_nullable_to_non_nullable
                  as OrderSaleChannel?,
      ),
    );
  }
}

/// @nodoc

class _$OrderListFiltersImpl extends _OrderListFilters {
  const _$OrderListFiltersImpl({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.status,
    this.paymentStatus,
    this.fromDate,
    this.toDate,
    this.saleChannel,
  }) : super._();

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  final String? search;
  @override
  final OrderStatus? status;
  @override
  final OrderPaymentStatus? paymentStatus;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final OrderSaleChannel? saleChannel;

  @override
  String toString() {
    return 'OrderListFilters(page: $page, limit: $limit, search: $search, status: $status, paymentStatus: $paymentStatus, fromDate: $fromDate, toDate: $toDate, saleChannel: $saleChannel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderListFiltersImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.saleChannel, saleChannel) ||
                other.saleChannel == saleChannel));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    limit,
    search,
    status,
    paymentStatus,
    fromDate,
    toDate,
    saleChannel,
  );

  /// Create a copy of OrderListFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderListFiltersImplCopyWith<_$OrderListFiltersImpl> get copyWith =>
      __$$OrderListFiltersImplCopyWithImpl<_$OrderListFiltersImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderListFilters extends OrderListFilters {
  const factory _OrderListFilters({
    final int page,
    final int limit,
    final String? search,
    final OrderStatus? status,
    final OrderPaymentStatus? paymentStatus,
    final DateTime? fromDate,
    final DateTime? toDate,
    final OrderSaleChannel? saleChannel,
  }) = _$OrderListFiltersImpl;
  const _OrderListFilters._() : super._();

  @override
  int get page;
  @override
  int get limit;
  @override
  String? get search;
  @override
  OrderStatus? get status;
  @override
  OrderPaymentStatus? get paymentStatus;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;
  @override
  OrderSaleChannel? get saleChannel;

  /// Create a copy of OrderListFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderListFiltersImplCopyWith<_$OrderListFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
