//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_container_lots_response.g.dart';

/// CreateContainerLotsResponse
///
/// Properties:
/// * [success] 
/// * [error] 
/// * [createdIds] 
@BuiltValue()
abstract class CreateContainerLotsResponse implements Built<CreateContainerLotsResponse, CreateContainerLotsResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'createdIds')
  BuiltList<String>? get createdIds;

  CreateContainerLotsResponse._();

  factory CreateContainerLotsResponse([void updates(CreateContainerLotsResponseBuilder b)]) = _$CreateContainerLotsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateContainerLotsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateContainerLotsResponse> get serializer => _$CreateContainerLotsResponseSerializer();
}

class _$CreateContainerLotsResponseSerializer implements PrimitiveSerializer<CreateContainerLotsResponse> {
  @override
  final Iterable<Type> types = const [CreateContainerLotsResponse, _$CreateContainerLotsResponse];

  @override
  final String wireName = r'CreateContainerLotsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateContainerLotsResponse object, {
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
    if (object.createdIds != null) {
      yield r'createdIds';
      yield serializers.serialize(
        object.createdIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateContainerLotsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateContainerLotsResponseBuilder result,
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
        case r'createdIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.createdIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateContainerLotsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateContainerLotsResponseBuilder();
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

