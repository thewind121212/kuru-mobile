//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_container_lot_response.g.dart';

/// DeleteContainerLotResponse
///
/// Properties:
/// * [success]
/// * [error]
@BuiltValue()
abstract class DeleteContainerLotResponse
    implements
        Built<DeleteContainerLotResponse, DeleteContainerLotResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  DeleteContainerLotResponse._();

  factory DeleteContainerLotResponse([
    void updates(DeleteContainerLotResponseBuilder b),
  ]) = _$DeleteContainerLotResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteContainerLotResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteContainerLotResponse> get serializer =>
      _$DeleteContainerLotResponseSerializer();
}

class _$DeleteContainerLotResponseSerializer
    implements PrimitiveSerializer<DeleteContainerLotResponse> {
  @override
  final Iterable<Type> types = const [
    DeleteContainerLotResponse,
    _$DeleteContainerLotResponse,
  ];

  @override
  final String wireName = r'DeleteContainerLotResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteContainerLotResponse object, {
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
    DeleteContainerLotResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteContainerLotResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.success = valueDes;
          break;
        case r'error':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  DeleteContainerLotResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteContainerLotResponseBuilder();
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
