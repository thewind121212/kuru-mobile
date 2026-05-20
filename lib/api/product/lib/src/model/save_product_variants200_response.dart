//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/save_product_variants_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_product_variants200_response.g.dart';

/// SaveProductVariants200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class SaveProductVariants200Response implements Built<SaveProductVariants200Response, SaveProductVariants200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  SaveProductVariantsResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  SaveProductVariants200Response._();

  factory SaveProductVariants200Response([void updates(SaveProductVariants200ResponseBuilder b)]) = _$SaveProductVariants200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveProductVariants200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveProductVariants200Response> get serializer => _$SaveProductVariants200ResponseSerializer();
}

class _$SaveProductVariants200ResponseSerializer implements PrimitiveSerializer<SaveProductVariants200Response> {
  @override
  final Iterable<Type> types = const [SaveProductVariants200Response, _$SaveProductVariants200Response];

  @override
  final String wireName = r'SaveProductVariants200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveProductVariants200Response object, {
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
      specifiedType: const FullType(SaveProductVariantsResponse),
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
    SaveProductVariants200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveProductVariants200ResponseBuilder result,
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
            specifiedType: const FullType(SaveProductVariantsResponse),
          ) as SaveProductVariantsResponse;
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
  SaveProductVariants200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveProductVariants200ResponseBuilder();
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

