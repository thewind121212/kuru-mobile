//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/update_product_info_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_info200_response.g.dart';

/// UpdateProductInfo200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class UpdateProductInfo200Response implements Built<UpdateProductInfo200Response, UpdateProductInfo200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  UpdateProductInfoResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  UpdateProductInfo200Response._();

  factory UpdateProductInfo200Response([void updates(UpdateProductInfo200ResponseBuilder b)]) = _$UpdateProductInfo200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductInfo200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductInfo200Response> get serializer => _$UpdateProductInfo200ResponseSerializer();
}

class _$UpdateProductInfo200ResponseSerializer implements PrimitiveSerializer<UpdateProductInfo200Response> {
  @override
  final Iterable<Type> types = const [UpdateProductInfo200Response, _$UpdateProductInfo200Response];

  @override
  final String wireName = r'UpdateProductInfo200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductInfo200Response object, {
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
      specifiedType: const FullType(UpdateProductInfoResponse),
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
    UpdateProductInfo200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProductInfo200ResponseBuilder result,
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
            specifiedType: const FullType(UpdateProductInfoResponse),
          ) as UpdateProductInfoResponse;
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
  UpdateProductInfo200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductInfo200ResponseBuilder();
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

