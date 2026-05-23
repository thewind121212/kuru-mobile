// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderDetail {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  OrderPaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  OrderSaleChannel get saleChannel => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  double get changeAmount => throw _privateConstructorUsedError;
  List<OrderLineItem> get items => throw _privateConstructorUsedError;
  List<OrderPayment> get payments => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DiscountType? get discountType => throw _privateConstructorUsedError;
  double? get discountValue => throw _privateConstructorUsedError;
  String? get taxRateId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError;
  DateTime? get fulfilledAt => throw _privateConstructorUsedError;
  String? get fulfilledBy => throw _privateConstructorUsedError;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailCopyWith<OrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailCopyWith<$Res> {
  factory $OrderDetailCopyWith(
    OrderDetail value,
    $Res Function(OrderDetail) then,
  ) = _$OrderDetailCopyWithImpl<$Res, OrderDetail>;
  @useResult
  $Res call({
    String id,
    String orgId,
    String orderNumber,
    OrderStatus status,
    OrderPaymentStatus paymentStatus,
    double subtotal,
    double totalAmount,
    DateTime createdAt,
    DateTime updatedAt,
    String createdBy,
    int itemCount,
    OrderSaleChannel saleChannel,
    double discountAmount,
    double taxAmount,
    double paidAmount,
    double changeAmount,
    List<OrderLineItem> items,
    List<OrderPayment> payments,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    String? taxRateId,
    String? storeId,
    String? storeName,
    DateTime? fulfilledAt,
    String? fulfilledBy,
  });
}

/// @nodoc
class _$OrderDetailCopyWithImpl<$Res, $Val extends OrderDetail>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? subtotal = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
    Object? itemCount = null,
    Object? saleChannel = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? changeAmount = null,
    Object? items = null,
    Object? payments = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? note = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
    Object? taxRateId = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? fulfilledAt = freezed,
    Object? fulfilledBy = freezed,
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
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            saleChannel: null == saleChannel
                ? _value.saleChannel
                : saleChannel // ignore: cast_nullable_to_non_nullable
                      as OrderSaleChannel,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            changeAmount: null == changeAmount
                ? _value.changeAmount
                : changeAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderLineItem>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<OrderPayment>,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountType: freezed == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as DiscountType?,
            discountValue: freezed == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            taxRateId: freezed == taxRateId
                ? _value.taxRateId
                : taxRateId // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeId: freezed == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeName: freezed == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            fulfilledAt: freezed == fulfilledAt
                ? _value.fulfilledAt
                : fulfilledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            fulfilledBy: freezed == fulfilledBy
                ? _value.fulfilledBy
                : fulfilledBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDetailImplCopyWith<$Res>
    implements $OrderDetailCopyWith<$Res> {
  factory _$$OrderDetailImplCopyWith(
    _$OrderDetailImpl value,
    $Res Function(_$OrderDetailImpl) then,
  ) = __$$OrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orgId,
    String orderNumber,
    OrderStatus status,
    OrderPaymentStatus paymentStatus,
    double subtotal,
    double totalAmount,
    DateTime createdAt,
    DateTime updatedAt,
    String createdBy,
    int itemCount,
    OrderSaleChannel saleChannel,
    double discountAmount,
    double taxAmount,
    double paidAmount,
    double changeAmount,
    List<OrderLineItem> items,
    List<OrderPayment> payments,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    String? taxRateId,
    String? storeId,
    String? storeName,
    DateTime? fulfilledAt,
    String? fulfilledBy,
  });
}

/// @nodoc
class __$$OrderDetailImplCopyWithImpl<$Res>
    extends _$OrderDetailCopyWithImpl<$Res, _$OrderDetailImpl>
    implements _$$OrderDetailImplCopyWith<$Res> {
  __$$OrderDetailImplCopyWithImpl(
    _$OrderDetailImpl _value,
    $Res Function(_$OrderDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? subtotal = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = null,
    Object? itemCount = null,
    Object? saleChannel = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? changeAmount = null,
    Object? items = null,
    Object? payments = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? note = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
    Object? taxRateId = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? fulfilledAt = freezed,
    Object? fulfilledBy = freezed,
  }) {
    return _then(
      _$OrderDetailImpl(
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
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        saleChannel: null == saleChannel
            ? _value.saleChannel
            : saleChannel // ignore: cast_nullable_to_non_nullable
                  as OrderSaleChannel,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        changeAmount: null == changeAmount
            ? _value.changeAmount
            : changeAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderLineItem>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<OrderPayment>,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountType: freezed == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as DiscountType?,
        discountValue: freezed == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        taxRateId: freezed == taxRateId
            ? _value.taxRateId
            : taxRateId // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeId: freezed == storeId
            ? _value.storeId
            : storeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeName: freezed == storeName
            ? _value.storeName
            : storeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        fulfilledAt: freezed == fulfilledAt
            ? _value.fulfilledAt
            : fulfilledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        fulfilledBy: freezed == fulfilledBy
            ? _value.fulfilledBy
            : fulfilledBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OrderDetailImpl extends _OrderDetail {
  const _$OrderDetailImpl({
    required this.id,
    required this.orgId,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.subtotal,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.itemCount,
    required this.saleChannel,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.paidAmount = 0,
    this.changeAmount = 0,
    final List<OrderLineItem> items = const <OrderLineItem>[],
    final List<OrderPayment> payments = const <OrderPayment>[],
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.note,
    this.discountType,
    this.discountValue,
    this.taxRateId,
    this.storeId,
    this.storeName,
    this.fulfilledAt,
    this.fulfilledBy,
  }) : _items = items,
       _payments = payments,
       super._();

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
  final double subtotal;
  @override
  final double totalAmount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String createdBy;
  @override
  final int itemCount;
  @override
  final OrderSaleChannel saleChannel;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double paidAmount;
  @override
  @JsonKey()
  final double changeAmount;
  final List<OrderLineItem> _items;
  @override
  @JsonKey()
  List<OrderLineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<OrderPayment> _payments;
  @override
  @JsonKey()
  List<OrderPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final String? customerId;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? note;
  @override
  final DiscountType? discountType;
  @override
  final double? discountValue;
  @override
  final String? taxRateId;
  @override
  final String? storeId;
  @override
  final String? storeName;
  @override
  final DateTime? fulfilledAt;
  @override
  final String? fulfilledBy;

  @override
  String toString() {
    return 'OrderDetail(id: $id, orgId: $orgId, orderNumber: $orderNumber, status: $status, paymentStatus: $paymentStatus, subtotal: $subtotal, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, itemCount: $itemCount, saleChannel: $saleChannel, discountAmount: $discountAmount, taxAmount: $taxAmount, paidAmount: $paidAmount, changeAmount: $changeAmount, items: $items, payments: $payments, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, note: $note, discountType: $discountType, discountValue: $discountValue, taxRateId: $taxRateId, storeId: $storeId, storeName: $storeName, fulfilledAt: $fulfilledAt, fulfilledBy: $fulfilledBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.saleChannel, saleChannel) ||
                other.saleChannel == saleChannel) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.taxRateId, taxRateId) ||
                other.taxRateId == taxRateId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.fulfilledAt, fulfilledAt) ||
                other.fulfilledAt == fulfilledAt) &&
            (identical(other.fulfilledBy, fulfilledBy) ||
                other.fulfilledBy == fulfilledBy));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orgId,
    orderNumber,
    status,
    paymentStatus,
    subtotal,
    totalAmount,
    createdAt,
    updatedAt,
    createdBy,
    itemCount,
    saleChannel,
    discountAmount,
    taxAmount,
    paidAmount,
    changeAmount,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_payments),
    customerId,
    customerName,
    customerPhone,
    note,
    discountType,
    discountValue,
    taxRateId,
    storeId,
    storeName,
    fulfilledAt,
    fulfilledBy,
  ]);

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      __$$OrderDetailImplCopyWithImpl<_$OrderDetailImpl>(this, _$identity);
}

abstract class _OrderDetail extends OrderDetail {
  const factory _OrderDetail({
    required final String id,
    required final String orgId,
    required final String orderNumber,
    required final OrderStatus status,
    required final OrderPaymentStatus paymentStatus,
    required final double subtotal,
    required final double totalAmount,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final String createdBy,
    required final int itemCount,
    required final OrderSaleChannel saleChannel,
    final double discountAmount,
    final double taxAmount,
    final double paidAmount,
    final double changeAmount,
    final List<OrderLineItem> items,
    final List<OrderPayment> payments,
    final String? customerId,
    final String? customerName,
    final String? customerPhone,
    final String? note,
    final DiscountType? discountType,
    final double? discountValue,
    final String? taxRateId,
    final String? storeId,
    final String? storeName,
    final DateTime? fulfilledAt,
    final String? fulfilledBy,
  }) = _$OrderDetailImpl;
  const _OrderDetail._() : super._();

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
  double get subtotal;
  @override
  double get totalAmount;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get createdBy;
  @override
  int get itemCount;
  @override
  OrderSaleChannel get saleChannel;
  @override
  double get discountAmount;
  @override
  double get taxAmount;
  @override
  double get paidAmount;
  @override
  double get changeAmount;
  @override
  List<OrderLineItem> get items;
  @override
  List<OrderPayment> get payments;
  @override
  String? get customerId;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get note;
  @override
  DiscountType? get discountType;
  @override
  double? get discountValue;
  @override
  String? get taxRateId;
  @override
  String? get storeId;
  @override
  String? get storeName;
  @override
  DateTime? get fulfilledAt;
  @override
  String? get fulfilledBy;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
