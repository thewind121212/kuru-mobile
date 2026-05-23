// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderPayment {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  OrderPaymentMethod get method => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get paidAt => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentCopyWith<OrderPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentCopyWith<$Res> {
  factory $OrderPaymentCopyWith(
    OrderPayment value,
    $Res Function(OrderPayment) then,
  ) = _$OrderPaymentCopyWithImpl<$Res, OrderPayment>;
  @useResult
  $Res call({
    String id,
    String orderId,
    OrderPaymentMethod method,
    double amount,
    DateTime paidAt,
    String? reference,
    String? note,
  });
}

/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res, $Val extends OrderPayment>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidAt = null,
    Object? reference = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentMethod,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAt: null == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderPaymentImplCopyWith<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  factory _$$OrderPaymentImplCopyWith(
    _$OrderPaymentImpl value,
    $Res Function(_$OrderPaymentImpl) then,
  ) = __$$OrderPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    OrderPaymentMethod method,
    double amount,
    DateTime paidAt,
    String? reference,
    String? note,
  });
}

/// @nodoc
class __$$OrderPaymentImplCopyWithImpl<$Res>
    extends _$OrderPaymentCopyWithImpl<$Res, _$OrderPaymentImpl>
    implements _$$OrderPaymentImplCopyWith<$Res> {
  __$$OrderPaymentImplCopyWithImpl(
    _$OrderPaymentImpl _value,
    $Res Function(_$OrderPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidAt = null,
    Object? reference = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$OrderPaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentMethod,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAt: null == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OrderPaymentImpl extends _OrderPayment {
  const _$OrderPaymentImpl({
    required this.id,
    required this.orderId,
    required this.method,
    required this.amount,
    required this.paidAt,
    this.reference,
    this.note,
  }) : super._();

  @override
  final String id;
  @override
  final String orderId;
  @override
  final OrderPaymentMethod method;
  @override
  final double amount;
  @override
  final DateTime paidAt;
  @override
  final String? reference;
  @override
  final String? note;

  @override
  String toString() {
    return 'OrderPayment(id: $id, orderId: $orderId, method: $method, amount: $amount, paidAt: $paidAt, reference: $reference, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    method,
    amount,
    paidAt,
    reference,
    note,
  );

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      __$$OrderPaymentImplCopyWithImpl<_$OrderPaymentImpl>(this, _$identity);
}

abstract class _OrderPayment extends OrderPayment {
  const factory _OrderPayment({
    required final String id,
    required final String orderId,
    required final OrderPaymentMethod method,
    required final double amount,
    required final DateTime paidAt,
    final String? reference,
    final String? note,
  }) = _$OrderPaymentImpl;
  const _OrderPayment._() : super._();

  @override
  String get id;
  @override
  String get orderId;
  @override
  OrderPaymentMethod get method;
  @override
  double get amount;
  @override
  DateTime get paidAt;
  @override
  String? get reference;
  @override
  String? get note;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
