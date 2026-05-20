// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_lot_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeleteLotReason _$LOSS = const DeleteLotReason._('LOSS');
const DeleteLotReason _$STOCK_TAKE = const DeleteLotReason._('STOCK_TAKE');
const DeleteLotReason _$DAMAGE = const DeleteLotReason._('DAMAGE');
const DeleteLotReason _$OTHER = const DeleteLotReason._('OTHER');

DeleteLotReason _$valueOf(String name) {
  switch (name) {
    case 'LOSS':
      return _$LOSS;
    case 'STOCK_TAKE':
      return _$STOCK_TAKE;
    case 'DAMAGE':
      return _$DAMAGE;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeleteLotReason> _$values = BuiltSet<DeleteLotReason>(
  const <DeleteLotReason>[_$LOSS, _$STOCK_TAKE, _$DAMAGE, _$OTHER],
);

class _$DeleteLotReasonMeta {
  const _$DeleteLotReasonMeta();
  DeleteLotReason get LOSS => _$LOSS;
  DeleteLotReason get STOCK_TAKE => _$STOCK_TAKE;
  DeleteLotReason get DAMAGE => _$DAMAGE;
  DeleteLotReason get OTHER => _$OTHER;
  DeleteLotReason valueOf(String name) => _$valueOf(name);
  BuiltSet<DeleteLotReason> get values => _$values;
}

mixin _$DeleteLotReasonMixin {
  // ignore: non_constant_identifier_names
  _$DeleteLotReasonMeta get DeleteLotReason => const _$DeleteLotReasonMeta();
}

Serializer<DeleteLotReason> _$deleteLotReasonSerializer =
    _$DeleteLotReasonSerializer();

class _$DeleteLotReasonSerializer
    implements PrimitiveSerializer<DeleteLotReason> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOSS': 'LOSS',
    'STOCK_TAKE': 'STOCK_TAKE',
    'DAMAGE': 'DAMAGE',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOSS': 'LOSS',
    'STOCK_TAKE': 'STOCK_TAKE',
    'DAMAGE': 'DAMAGE',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[DeleteLotReason];
  @override
  final String wireName = 'DeleteLotReason';

  @override
  Object serialize(
    Serializers serializers,
    DeleteLotReason object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DeleteLotReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DeleteLotReason.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
