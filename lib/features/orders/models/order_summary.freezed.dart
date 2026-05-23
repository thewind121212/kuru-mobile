// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderSummary {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  OrderPaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  OrderSaleChannel get saleChannel => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError;

  /// Create a copy of OrderSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderSummaryCopyWith<OrderSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderSummaryCopyWith<$Res> {
  factory $OrderSummaryCopyWith(
    OrderSummary value,
    $Res Function(OrderSummary) then,
  ) = _$OrderSummaryCopyWithImpl<$Res, OrderSummary>;
  @useResult
  $Res call({
    String id,
    String orgId,
    String orderNumber,
    OrderStatus status,
    OrderPaymentStatus paymentStatus,
    double totalAmount,
    double paidAmount,
    int itemCount,
    DateTime createdAt,
    OrderSaleChannel saleChannel,
    String? customerName,
    String? storeId,
    String? storeName,
  });
}

/// @nodoc
class _$OrderSummaryCopyWithImpl<$Res, $Val extends OrderSummary>
    implements $OrderSummaryCopyWith<$Res> {
  _$OrderSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? itemCount = null,
    Object? createdAt = null,
    Object? saleChannel = null,
    Object? customerName = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orgId: null == orgId
                ? _value.orgId
                : orgId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentStatus,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            saleChannel: null == saleChannel
                ? _value.saleChannel
                : saleChannel // ignore: cast_nullable_to_non_nullable
                      as OrderSaleChannel,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeId: freezed == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeName: freezed == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderSummaryImplCopyWith<$Res>
    implements $OrderSummaryCopyWith<$Res> {
  factory _$$OrderSummaryImplCopyWith(
    _$OrderSummaryImpl value,
    $Res Function(_$OrderSummaryImpl) then,
  ) = __$$OrderSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orgId,
    String orderNumber,
    OrderStatus status,
    OrderPaymentStatus paymentStatus,
    double totalAmount,
    double paidAmount,
    int itemCount,
    DateTime createdAt,
    OrderSaleChannel saleChannel,
    String? customerName,
    String? storeId,
    String? storeName,
  });
}

/// @nodoc
class __$$OrderSummaryImplCopyWithImpl<$Res>
    extends _$OrderSummaryCopyWithImpl<$Res, _$OrderSummaryImpl>
    implements _$$OrderSummaryImplCopyWith<$Res> {
  __$$OrderSummaryImplCopyWithImpl(
    _$OrderSummaryImpl _value,
    $Res Function(_$OrderSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? itemCount = null,
    Object? createdAt = null,
    Object? saleChannel = null,
    Object? customerName = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
  }) {
    return _then(
      _$OrderSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orgId: null == orgId
            ? _value.orgId
            : orgId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentStatus,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        saleChannel: null == saleChannel
            ? _value.saleChannel
            : saleChannel // ignore: cast_nullable_to_non_nullable
                  as OrderSaleChannel,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeId: freezed == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeName: freezed == storeName
            ? _value.storeName
            : storeName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OrderSummaryImpl extends _OrderSummary {
  const _$OrderSummaryImpl({
    required this.id,
    required this.orgId,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.paidAmount,
    required this.itemCount,
    required this.createdAt,
    required this.saleChannel,
    this.customerName,
    this.storeId,
    this.storeName,
  }) : super._();

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String orderNumber;
  @override
  final OrderStatus status;
  @override
  final OrderPaymentStatus paymentStatus;
  @override
  final double totalAmount;
  @override
  final double paidAmount;
  @override
  final int itemCount;
  @override
  final DateTime createdAt;
  @override
  final OrderSaleChannel saleChannel;
  @override
  final String? customerName;
  @override
  final String? storeId;
  @override
  final String? storeName;

  @override
  String toString() {
    return 'OrderSummary(id: $id, orgId: $orgId, orderNumber: $orderNumber, status: $status, paymentStatus: $paymentStatus, totalAmount: $totalAmount, paidAmount: $paidAmount, itemCount: $itemCount, createdAt: $createdAt, saleChannel: $saleChannel, customerName: $customerName, storeId: $storeId, storeName: $storeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.saleChannel, saleChannel) ||
                other.saleChannel == saleChannel) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orgId,
    orderNumber,
    status,
    paymentStatus,
    totalAmount,
    paidAmount,
    itemCount,
    createdAt,
    saleChannel,
    customerName,
    storeId,
    storeName,
  );

  /// Create a copy of OrderSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderSummaryImplCopyWith<_$OrderSummaryImpl> get copyWith =>
      __$$OrderSummaryImplCopyWithImpl<_$OrderSummaryImpl>(this, _$identity);
}

abstract class _OrderSummary extends OrderSummary {
  const factory _OrderSummary({
    required final String id,
    required final String orgId,
    required final String orderNumber,
    required final OrderStatus status,
    required final OrderPaymentStatus paymentStatus,
    required final double totalAmount,
    required final double paidAmount,
    required final int itemCount,
    required final DateTime createdAt,
    required final OrderSaleChannel saleChannel,
    final String? customerName,
    final String? storeId,
    final String? storeName,
  }) = _$OrderSummaryImpl;
  const _OrderSummary._() : super._();

  @override
  String get id;
  @override
  String get orgId;
  @override
  String get orderNumber;
  @override
  OrderStatus get status;
  @override
  OrderPaymentStatus get paymentStatus;
  @override
  double get totalAmount;
  @override
  double get paidAmount;
  @override
  int get itemCount;
  @override
  DateTime get createdAt;
  @override
  OrderSaleChannel get saleChannel;
  @override
  String? get customerName;
  @override
  String? get storeId;
  @override
  String? get storeName;

  /// Create a copy of OrderSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderSummaryImplCopyWith<_$OrderSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
