// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_cart_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderCartTotals {
  double get subtotal => throw _privateConstructorUsedError;
  double get orderDiscountAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Create a copy of OrderCartTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCartTotalsCopyWith<OrderCartTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCartTotalsCopyWith<$Res> {
  factory $OrderCartTotalsCopyWith(
    OrderCartTotals value,
    $Res Function(OrderCartTotals) then,
  ) = _$OrderCartTotalsCopyWithImpl<$Res, OrderCartTotals>;
  @useResult
  $Res call({
    double subtotal,
    double orderDiscountAmount,
    double taxAmount,
    double total,
  });
}

/// @nodoc
class _$OrderCartTotalsCopyWithImpl<$Res, $Val extends OrderCartTotals>
    implements $OrderCartTotalsCopyWith<$Res> {
  _$OrderCartTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCartTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? orderDiscountAmount = null,
    Object? taxAmount = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            orderDiscountAmount: null == orderDiscountAmount
                ? _value.orderDiscountAmount
                : orderDiscountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCartTotalsImplCopyWith<$Res>
    implements $OrderCartTotalsCopyWith<$Res> {
  factory _$$OrderCartTotalsImplCopyWith(
    _$OrderCartTotalsImpl value,
    $Res Function(_$OrderCartTotalsImpl) then,
  ) = __$$OrderCartTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double subtotal,
    double orderDiscountAmount,
    double taxAmount,
    double total,
  });
}

/// @nodoc
class __$$OrderCartTotalsImplCopyWithImpl<$Res>
    extends _$OrderCartTotalsCopyWithImpl<$Res, _$OrderCartTotalsImpl>
    implements _$$OrderCartTotalsImplCopyWith<$Res> {
  __$$OrderCartTotalsImplCopyWithImpl(
    _$OrderCartTotalsImpl _value,
    $Res Function(_$OrderCartTotalsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCartTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? orderDiscountAmount = null,
    Object? taxAmount = null,
    Object? total = null,
  }) {
    return _then(
      _$OrderCartTotalsImpl(
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        orderDiscountAmount: null == orderDiscountAmount
            ? _value.orderDiscountAmount
            : orderDiscountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$OrderCartTotalsImpl implements _OrderCartTotals {
  const _$OrderCartTotalsImpl({
    required this.subtotal,
    required this.orderDiscountAmount,
    required this.taxAmount,
    required this.total,
  });

  @override
  final double subtotal;
  @override
  final double orderDiscountAmount;
  @override
  final double taxAmount;
  @override
  final double total;

  @override
  String toString() {
    return 'OrderCartTotals(subtotal: $subtotal, orderDiscountAmount: $orderDiscountAmount, taxAmount: $taxAmount, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCartTotalsImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.orderDiscountAmount, orderDiscountAmount) ||
                other.orderDiscountAmount == orderDiscountAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, subtotal, orderDiscountAmount, taxAmount, total);

  /// Create a copy of OrderCartTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCartTotalsImplCopyWith<_$OrderCartTotalsImpl> get copyWith =>
      __$$OrderCartTotalsImplCopyWithImpl<_$OrderCartTotalsImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderCartTotals implements OrderCartTotals {
  const factory _OrderCartTotals({
    required final double subtotal,
    required final double orderDiscountAmount,
    required final double taxAmount,
    required final double total,
  }) = _$OrderCartTotalsImpl;

  @override
  double get subtotal;
  @override
  double get orderDiscountAmount;
  @override
  double get taxAmount;
  @override
  double get total;

  /// Create a copy of OrderCartTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCartTotalsImplCopyWith<_$OrderCartTotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
