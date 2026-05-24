// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderLineItem {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get baseUnitCode => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  DiscountType? get discountType => throw _privateConstructorUsedError;
  double? get discountValue => throw _privateConstructorUsedError;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderLineItemCopyWith<OrderLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderLineItemCopyWith<$Res> {
  factory $OrderLineItemCopyWith(
    OrderLineItem value,
    $Res Function(OrderLineItem) then,
  ) = _$OrderLineItemCopyWithImpl<$Res, OrderLineItem>;
  @useResult
  $Res call({
    String productId,
    String productName,
    String baseUnitCode,
    double qty,
    double unitPrice,
    double discountAmount,
    double totalAmount,
    String? id,
    String? orderId,
    String? variantId,
    String? variantName,
    String? imageUrl,
    String? barcode,
    DiscountType? discountType,
    double? discountValue,
  });
}

/// @nodoc
class _$OrderLineItemCopyWithImpl<$Res, $Val extends OrderLineItem>
    implements $OrderLineItemCopyWith<$Res> {
  _$OrderLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? baseUnitCode = null,
    Object? qty = null,
    Object? unitPrice = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? id = freezed,
    Object? orderId = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? imageUrl = freezed,
    Object? barcode = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            baseUnitCode: null == baseUnitCode
                ? _value.baseUnitCode
                : baseUnitCode // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as double,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderId: freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            variantName: freezed == variantName
                ? _value.variantName
                : variantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountType: freezed == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as DiscountType?,
            discountValue: freezed == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderLineItemImplCopyWith<$Res>
    implements $OrderLineItemCopyWith<$Res> {
  factory _$$OrderLineItemImplCopyWith(
    _$OrderLineItemImpl value,
    $Res Function(_$OrderLineItemImpl) then,
  ) = __$$OrderLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    String baseUnitCode,
    double qty,
    double unitPrice,
    double discountAmount,
    double totalAmount,
    String? id,
    String? orderId,
    String? variantId,
    String? variantName,
    String? imageUrl,
    String? barcode,
    DiscountType? discountType,
    double? discountValue,
  });
}

/// @nodoc
class __$$OrderLineItemImplCopyWithImpl<$Res>
    extends _$OrderLineItemCopyWithImpl<$Res, _$OrderLineItemImpl>
    implements _$$OrderLineItemImplCopyWith<$Res> {
  __$$OrderLineItemImplCopyWithImpl(
    _$OrderLineItemImpl _value,
    $Res Function(_$OrderLineItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? baseUnitCode = null,
    Object? qty = null,
    Object? unitPrice = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? id = freezed,
    Object? orderId = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? imageUrl = freezed,
    Object? barcode = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
  }) {
    return _then(
      _$OrderLineItemImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        baseUnitCode: null == baseUnitCode
            ? _value.baseUnitCode
            : baseUnitCode // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as double,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderId: freezed == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        variantName: freezed == variantName
            ? _value.variantName
            : variantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountType: freezed == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as DiscountType?,
        discountValue: freezed == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$OrderLineItemImpl extends _OrderLineItem {
  const _$OrderLineItemImpl({
    required this.productId,
    required this.productName,
    required this.baseUnitCode,
    required this.qty,
    required this.unitPrice,
    this.discountAmount = 0,
    this.totalAmount = 0,
    this.id,
    this.orderId,
    this.variantId,
    this.variantName,
    this.imageUrl,
    this.barcode,
    this.discountType,
    this.discountValue,
  }) : super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String baseUnitCode;
  @override
  final double qty;
  @override
  final double unitPrice;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  final String? id;
  @override
  final String? orderId;
  @override
  final String? variantId;
  @override
  final String? variantName;
  @override
  final String? imageUrl;
  @override
  final String? barcode;
  @override
  final DiscountType? discountType;
  @override
  final double? discountValue;

  @override
  String toString() {
    return 'OrderLineItem(productId: $productId, productName: $productName, baseUnitCode: $baseUnitCode, qty: $qty, unitPrice: $unitPrice, discountAmount: $discountAmount, totalAmount: $totalAmount, id: $id, orderId: $orderId, variantId: $variantId, variantName: $variantName, imageUrl: $imageUrl, barcode: $barcode, discountType: $discountType, discountValue: $discountValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLineItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.baseUnitCode, baseUnitCode) ||
                other.baseUnitCode == baseUnitCode) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productName,
    baseUnitCode,
    qty,
    unitPrice,
    discountAmount,
    totalAmount,
    id,
    orderId,
    variantId,
    variantName,
    imageUrl,
    barcode,
    discountType,
    discountValue,
  );

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      __$$OrderLineItemImplCopyWithImpl<_$OrderLineItemImpl>(this, _$identity);
}

abstract class _OrderLineItem extends OrderLineItem {
  const factory _OrderLineItem({
    required final String productId,
    required final String productName,
    required final String baseUnitCode,
    required final double qty,
    required final double unitPrice,
    final double discountAmount,
    final double totalAmount,
    final String? id,
    final String? orderId,
    final String? variantId,
    final String? variantName,
    final String? imageUrl,
    final String? barcode,
    final DiscountType? discountType,
    final double? discountValue,
  }) = _$OrderLineItemImpl;
  const _OrderLineItem._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  String get baseUnitCode;
  @override
  double get qty;
  @override
  double get unitPrice;
  @override
  double get discountAmount;
  @override
  double get totalAmount;
  @override
  String? get id;
  @override
  String? get orderId;
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  String? get imageUrl;
  @override
  String? get barcode;
  @override
  DiscountType? get discountType;
  @override
  double? get discountValue;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
