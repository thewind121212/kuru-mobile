//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/create_product_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product200_response.g.dart';

/// CreateProduct200Response
///
/// Properties:
/// * [success]
/// * [data]
/// * [timestamp]
@BuiltValue()
abstract class CreateProduct200Response
    implements
        Built<CreateProduct200Response, CreateProduct200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  CreateProductResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  CreateProduct200Response._();

  factory CreateProduct200Response([
    void updates(CreateProduct200ResponseBuilder b),
  ]) = _$CreateProduct200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProduct200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProduct200Response> get serializer =>
      _$CreateProduct200ResponseSerializer();
}

class _$CreateProduct200ResponseSerializer
    implements PrimitiveSerializer<CreateProduct200Response> {
  @override
  final Iterable<Type> types = const [
    CreateProduct200Response,
    _$CreateProduct200Response,
  ];

  @override
  final String wireName = r'CreateProduct200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProduct200Response object, {
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
      specifiedType: const FullType(CreateProductResponse),
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
    CreateProduct200Response object, {
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
    required CreateProduct200ResponseBuilder result,
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
                    specifiedType: const FullType(CreateProductResponse),
                  )
                  as CreateProductResponse;
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
  CreateProduct200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProduct200ResponseBuilder();
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
