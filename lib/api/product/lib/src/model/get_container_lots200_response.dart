//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/get_container_lots_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_container_lots200_response.g.dart';

/// GetContainerLots200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class GetContainerLots200Response implements Built<GetContainerLots200Response, GetContainerLots200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  GetContainerLotsResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  GetContainerLots200Response._();

  factory GetContainerLots200Response([void updates(GetContainerLots200ResponseBuilder b)]) = _$GetContainerLots200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetContainerLots200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetContainerLots200Response> get serializer => _$GetContainerLots200ResponseSerializer();
}

class _$GetContainerLots200ResponseSerializer implements PrimitiveSerializer<GetContainerLots200Response> {
  @override
  final Iterable<Type> types = const [GetContainerLots200Response, _$GetContainerLots200Response];

  @override
  final String wireName = r'GetContainerLots200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetContainerLots200Response object, {
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
      specifiedType: const FullType(GetContainerLotsResponse),
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
    GetContainerLots200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetContainerLots200ResponseBuilder result,
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
            specifiedType: const FullType(GetContainerLotsResponse),
          ) as GetContainerLotsResponse;
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
  GetContainerLots200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetContainerLots200ResponseBuilder();
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

