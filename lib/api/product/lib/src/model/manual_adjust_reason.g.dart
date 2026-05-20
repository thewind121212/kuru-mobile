// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_adjust_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManualAdjustReason _$STOCK_TAKE = const ManualAdjustReason._(
  'STOCK_TAKE',
);
const ManualAdjustReason _$DAMAGE = const ManualAdjustReason._('DAMAGE');
const ManualAdjustReason _$LOSS = const ManualAdjustReason._('LOSS');
const ManualAdjustReason _$FOUND = const ManualAdjustReason._('FOUND');
const ManualAdjustReason _$RECEIPT_CORRECTION = const ManualAdjustReason._(
  'RECEIPT_CORRECTION',
);
const ManualAdjustReason _$OTHER = const ManualAdjustReason._('OTHER');

ManualAdjustReason _$valueOf(String name) {
  switch (name) {
    case 'STOCK_TAKE':
      return _$STOCK_TAKE;
    case 'DAMAGE':
      return _$DAMAGE;
    case 'LOSS':
      return _$LOSS;
    case 'FOUND':
      return _$FOUND;
    case 'RECEIPT_CORRECTION':
      return _$RECEIPT_CORRECTION;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManualAdjustReason> _$values = BuiltSet<ManualAdjustReason>(
  const <ManualAdjustReason>[
    _$STOCK_TAKE,
    _$DAMAGE,
    _$LOSS,
    _$FOUND,
    _$RECEIPT_CORRECTION,
    _$OTHER,
  ],
);

class _$ManualAdjustReasonMeta {
  const _$ManualAdjustReasonMeta();
  ManualAdjustReason get STOCK_TAKE => _$STOCK_TAKE;
  ManualAdjustReason get DAMAGE => _$DAMAGE;
  ManualAdjustReason get LOSS => _$LOSS;
  ManualAdjustReason get FOUND => _$FOUND;
  ManualAdjustReason get RECEIPT_CORRECTION => _$RECEIPT_CORRECTION;
  ManualAdjustReason get OTHER => _$OTHER;
  ManualAdjustReason valueOf(String name) => _$valueOf(name);
  BuiltSet<ManualAdjustReason> get values => _$values;
}

mixin _$ManualAdjustReasonMixin {
  // ignore: non_constant_identifier_names
  _$ManualAdjustReasonMeta get ManualAdjustReason =>
      const _$ManualAdjustReasonMeta();
}

Serializer<ManualAdjustReason> _$manualAdjustReasonSerializer =
    _$ManualAdjustReasonSerializer();

class _$ManualAdjustReasonSerializer
    implements PrimitiveSerializer<ManualAdjustReason> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STOCK_TAKE': 'STOCK_TAKE',
    'DAMAGE': 'DAMAGE',
    'LOSS': 'LOSS',
    'FOUND': 'FOUND',
    'RECEIPT_CORRECTION': 'RECEIPT_CORRECTION',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STOCK_TAKE': 'STOCK_TAKE',
    'DAMAGE': 'DAMAGE',
    'LOSS': 'LOSS',
    'FOUND': 'FOUND',
    'RECEIPT_CORRECTION': 'RECEIPT_CORRECTION',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[ManualAdjustReason];
  @override
  final String wireName = 'ManualAdjustReason';

  @override
  Object serialize(
    Serializers serializers,
    ManualAdjustReason object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ManualAdjustReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ManualAdjustReason.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
