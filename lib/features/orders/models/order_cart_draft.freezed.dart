// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_cart_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderCartDraft {
  List<OrderLineItem> get items => throw _privateConstructorUsedError;
  OrderSaleChannel get saleChannel => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DiscountType? get discountType => throw _privateConstructorUsedError;
  double? get discountValue => throw _privateConstructorUsedError;
  double? get manualTaxPercent => throw _privateConstructorUsedError;
  String? get idempotencyKey => throw _privateConstructorUsedError;

  /// Create a copy of OrderCartDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCartDraftCopyWith<OrderCartDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCartDraftCopyWith<$Res> {
  factory $OrderCartDraftCopyWith(
    OrderCartDraft value,
    $Res Function(OrderCartDraft) then,
  ) = _$OrderCartDraftCopyWithImpl<$Res, OrderCartDraft>;
  @useResult
  $Res call({
    List<OrderLineItem> items,
    OrderSaleChannel saleChannel,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    double? manualTaxPercent,
    String? idempotencyKey,
  });
}

/// @nodoc
class _$OrderCartDraftCopyWithImpl<$Res, $Val extends OrderCartDraft>
    implements $OrderCartDraftCopyWith<$Res> {
  _$OrderCartDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCartDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? saleChannel = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? note = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
    Object? manualTaxPercent = freezed,
    Object? idempotencyKey = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderLineItem>,
            saleChannel: null == saleChannel
                ? _value.saleChannel
                : saleChannel // ignore: cast_nullable_to_non_nullable
                      as OrderSaleChannel,
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
            manualTaxPercent: freezed == manualTaxPercent
                ? _value.manualTaxPercent
                : manualTaxPercent // ignore: cast_nullable_to_non_nullable
                      as double?,
            idempotencyKey: freezed == idempotencyKey
                ? _value.idempotencyKey
                : idempotencyKey // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCartDraftImplCopyWith<$Res>
    implements $OrderCartDraftCopyWith<$Res> {
  factory _$$OrderCartDraftImplCopyWith(
    _$OrderCartDraftImpl value,
    $Res Function(_$OrderCartDraftImpl) then,
  ) = __$$OrderCartDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<OrderLineItem> items,
    OrderSaleChannel saleChannel,
    String? customerName,
    String? customerPhone,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    double? manualTaxPercent,
    String? idempotencyKey,
  });
}

/// @nodoc
class __$$OrderCartDraftImplCopyWithImpl<$Res>
    extends _$OrderCartDraftCopyWithImpl<$Res, _$OrderCartDraftImpl>
    implements _$$OrderCartDraftImplCopyWith<$Res> {
  __$$OrderCartDraftImplCopyWithImpl(
    _$OrderCartDraftImpl _value,
    $Res Function(_$OrderCartDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCartDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? saleChannel = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? note = freezed,
    Object? discountType = freezed,
    Object? discountValue = freezed,
    Object? manualTaxPercent = freezed,
    Object? idempotencyKey = freezed,
  }) {
    return _then(
      _$OrderCartDraftImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderLineItem>,
        saleChannel: null == saleChannel
            ? _value.saleChannel
            : saleChannel // ignore: cast_nullable_to_non_nullable
                  as OrderSaleChannel,
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
        manualTaxPercent: freezed == manualTaxPercent
            ? _value.manualTaxPercent
            : manualTaxPercent // ignore: cast_nullable_to_non_nullable
                  as double?,
        idempotencyKey: freezed == idempotencyKey
            ? _value.idempotencyKey
            : idempotencyKey // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OrderCartDraftImpl extends _OrderCartDraft {
  const _$OrderCartDraftImpl({
    final List<OrderLineItem> items = const <OrderLineItem>[],
    this.saleChannel = OrderSaleChannel.shop,
    this.customerName,
    this.customerPhone,
    this.note,
    this.discountType,
    this.discountValue,
    this.manualTaxPercent,
    this.idempotencyKey,
  }) : _items = items,
       super._();

  final List<OrderLineItem> _items;
  @override
  @JsonKey()
  List<OrderLineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final OrderSaleChannel saleChannel;
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
  final double? manualTaxPercent;
  @override
  final String? idempotencyKey;

  @override
  String toString() {
    return 'OrderCartDraft(items: $items, saleChannel: $saleChannel, customerName: $customerName, customerPhone: $customerPhone, note: $note, discountType: $discountType, discountValue: $discountValue, manualTaxPercent: $manualTaxPercent, idempotencyKey: $idempotencyKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCartDraftImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.saleChannel, saleChannel) ||
                other.saleChannel == saleChannel) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.manualTaxPercent, manualTaxPercent) ||
                other.manualTaxPercent == manualTaxPercent) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    saleChannel,
    customerName,
    customerPhone,
    note,
    discountType,
    discountValue,
    manualTaxPercent,
    idempotencyKey,
  );

  /// Create a copy of OrderCartDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCartDraftImplCopyWith<_$OrderCartDraftImpl> get copyWith =>
      __$$OrderCartDraftImplCopyWithImpl<_$OrderCartDraftImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderCartDraft extends OrderCartDraft {
  const factory _OrderCartDraft({
    final List<OrderLineItem> items,
    final OrderSaleChannel saleChannel,
    final String? customerName,
    final String? customerPhone,
    final String? note,
    final DiscountType? discountType,
    final double? discountValue,
    final double? manualTaxPercent,
    final String? idempotencyKey,
  }) = _$OrderCartDraftImpl;
  const _OrderCartDraft._() : super._();

  @override
  List<OrderLineItem> get items;
  @override
  OrderSaleChannel get saleChannel;
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
  double? get manualTaxPercent;
  @override
  String? get idempotencyKey;

  /// Create a copy of OrderCartDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCartDraftImplCopyWith<_$OrderCartDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
