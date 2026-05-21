//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manual_adjust_reason.g.dart';

class ManualAdjustReason extends EnumClass {
  @BuiltValueEnumConst(wireName: r'STOCK_TAKE')
  static const ManualAdjustReason STOCK_TAKE = _$STOCK_TAKE;
  @BuiltValueEnumConst(wireName: r'DAMAGE')
  static const ManualAdjustReason DAMAGE = _$DAMAGE;
  @BuiltValueEnumConst(wireName: r'LOSS')
  static const ManualAdjustReason LOSS = _$LOSS;
  @BuiltValueEnumConst(wireName: r'FOUND')
  static const ManualAdjustReason FOUND = _$FOUND;
  @BuiltValueEnumConst(wireName: r'RECEIPT_CORRECTION')
  static const ManualAdjustReason RECEIPT_CORRECTION = _$RECEIPT_CORRECTION;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ManualAdjustReason OTHER = _$OTHER;

  static Serializer<ManualAdjustReason> get serializer =>
      _$manualAdjustReasonSerializer;

  const ManualAdjustReason._(String name) : super(name);

  static BuiltSet<ManualAdjustReason> get values => _$values;
  static ManualAdjustReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ManualAdjustReasonMixin = Object with _$ManualAdjustReasonMixin;
