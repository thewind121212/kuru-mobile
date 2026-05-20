//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_lot_reason.g.dart';

class DeleteLotReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LOSS')
  static const DeleteLotReason LOSS = _$LOSS;
  @BuiltValueEnumConst(wireName: r'STOCK_TAKE')
  static const DeleteLotReason STOCK_TAKE = _$STOCK_TAKE;
  @BuiltValueEnumConst(wireName: r'DAMAGE')
  static const DeleteLotReason DAMAGE = _$DAMAGE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DeleteLotReason OTHER = _$OTHER;

  static Serializer<DeleteLotReason> get serializer => _$deleteLotReasonSerializer;

  const DeleteLotReason._(String name): super(name);

  static BuiltSet<DeleteLotReason> get values => _$values;
  static DeleteLotReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DeleteLotReasonMixin = Object with _$DeleteLotReasonMixin;

