//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/manual_adjust_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjust_container_lot_request.g.dart';

/// AdjustContainerLotRequest
///
/// Properties:
/// * [containerLotId] 
/// * [newQtyRemaining] 
/// * [reason] 
/// * [note] 
@BuiltValue()
abstract class AdjustContainerLotRequest implements Built<AdjustContainerLotRequest, AdjustContainerLotRequestBuilder> {
  @BuiltValueField(wireName: r'containerLotId')
  String get containerLotId;

  @BuiltValueField(wireName: r'newQtyRemaining')
  double get newQtyRemaining;

  @BuiltValueField(wireName: r'reason')
  ManualAdjustReason get reason;
  // enum reasonEnum {  STOCK_TAKE,  DAMAGE,  LOSS,  FOUND,  RECEIPT_CORRECTION,  OTHER,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdjustContainerLotRequest._();

  factory AdjustContainerLotRequest([void updates(AdjustContainerLotRequestBuilder b)]) = _$AdjustContainerLotRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdjustContainerLotRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdjustContainerLotRequest> get serializer => _$AdjustContainerLotRequestSerializer();
}

class _$AdjustContainerLotRequestSerializer implements PrimitiveSerializer<AdjustContainerLotRequest> {
  @override
  final Iterable<Type> types = const [AdjustContainerLotRequest, _$AdjustContainerLotRequest];

  @override
  final String wireName = r'AdjustContainerLotRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdjustContainerLotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'containerLotId';
    yield serializers.serialize(
      object.containerLotId,
      specifiedType: const FullType(String),
    );
    yield r'newQtyRemaining';
    yield serializers.serialize(
      object.newQtyRemaining,
      specifiedType: const FullType(double),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ManualAdjustReason),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdjustContainerLotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdjustContainerLotRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'containerLotId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.containerLotId = valueDes;
          break;
        case r'newQtyRemaining':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.newQtyRemaining = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManualAdjustReason),
          ) as ManualAdjustReason;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdjustContainerLotRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdjustContainerLotRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

