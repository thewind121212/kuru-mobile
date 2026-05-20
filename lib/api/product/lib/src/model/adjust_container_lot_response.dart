//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjust_container_lot_response.g.dart';

/// AdjustContainerLotResponse
///
/// Properties:
/// * [success] 
/// * [error] 
@BuiltValue()
abstract class AdjustContainerLotResponse implements Built<AdjustContainerLotResponse, AdjustContainerLotResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  AdjustContainerLotResponse._();

  factory AdjustContainerLotResponse([void updates(AdjustContainerLotResponseBuilder b)]) = _$AdjustContainerLotResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdjustContainerLotResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdjustContainerLotResponse> get serializer => _$AdjustContainerLotResponseSerializer();
}

class _$AdjustContainerLotResponseSerializer implements PrimitiveSerializer<AdjustContainerLotResponse> {
  @override
  final Iterable<Type> types = const [AdjustContainerLotResponse, _$AdjustContainerLotResponse];

  @override
  final String wireName = r'AdjustContainerLotResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdjustContainerLotResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdjustContainerLotResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdjustContainerLotResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdjustContainerLotResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdjustContainerLotResponseBuilder();
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

