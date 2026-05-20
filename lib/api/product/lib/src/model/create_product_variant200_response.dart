//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/create_product_variant_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_variant200_response.g.dart';

/// CreateProductVariant200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class CreateProductVariant200Response implements Built<CreateProductVariant200Response, CreateProductVariant200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  CreateProductVariantResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  CreateProductVariant200Response._();

  factory CreateProductVariant200Response([void updates(CreateProductVariant200ResponseBuilder b)]) = _$CreateProductVariant200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductVariant200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductVariant200Response> get serializer => _$CreateProductVariant200ResponseSerializer();
}

class _$CreateProductVariant200ResponseSerializer implements PrimitiveSerializer<CreateProductVariant200Response> {
  @override
  final Iterable<Type> types = const [CreateProductVariant200Response, _$CreateProductVariant200Response];

  @override
  final String wireName = r'CreateProductVariant200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductVariant200Response object, {
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
      specifiedType: const FullType(CreateProductVariantResponse),
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
    CreateProductVariant200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateProductVariant200ResponseBuilder result,
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
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateProductVariantResponse),
          ) as CreateProductVariantResponse;
          result.data.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  CreateProductVariant200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductVariant200ResponseBuilder();
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

