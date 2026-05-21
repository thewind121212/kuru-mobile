//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/create_container_lots_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_container_lots200_response.g.dart';

/// CreateContainerLots200Response
///
/// Properties:
/// * [success]
/// * [data]
/// * [timestamp]
@BuiltValue()
abstract class CreateContainerLots200Response
    implements
        Built<
          CreateContainerLots200Response,
          CreateContainerLots200ResponseBuilder
        > {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  CreateContainerLotsResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  CreateContainerLots200Response._();

  factory CreateContainerLots200Response([
    void updates(CreateContainerLots200ResponseBuilder b),
  ]) = _$CreateContainerLots200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateContainerLots200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateContainerLots200Response> get serializer =>
      _$CreateContainerLots200ResponseSerializer();
}

class _$CreateContainerLots200ResponseSerializer
    implements PrimitiveSerializer<CreateContainerLots200Response> {
  @override
  final Iterable<Type> types = const [
    CreateContainerLots200Response,
    _$CreateContainerLots200Response,
  ];

  @override
  final String wireName = r'CreateContainerLots200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateContainerLots200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(CreateContainerLotsResponse),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateContainerLots200Response object, {
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
    required CreateContainerLots200ResponseBuilder result,
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
        case r'data':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CreateContainerLotsResponse),
                  )
                  as CreateContainerLotsResponse;
          result.data.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateContainerLots200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateContainerLots200ResponseBuilder();
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
