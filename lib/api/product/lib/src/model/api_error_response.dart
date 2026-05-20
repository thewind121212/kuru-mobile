//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/api_error_response_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error_response.g.dart';

/// ApiErrorResponse
///
/// Properties:
/// * [success] 
/// * [error] 
/// * [timestamp] 
@BuiltValue()
abstract class ApiErrorResponse implements Built<ApiErrorResponse, ApiErrorResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  ApiErrorResponseError get error;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  ApiErrorResponse._();

  factory ApiErrorResponse([void updates(ApiErrorResponseBuilder b)]) = _$ApiErrorResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiErrorResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiErrorResponse> get serializer => _$ApiErrorResponseSerializer();
}

class _$ApiErrorResponseSerializer implements PrimitiveSerializer<ApiErrorResponse> {
  @override
  final Iterable<Type> types = const [ApiErrorResponse, _$ApiErrorResponse];

  @override
  final String wireName = r'ApiErrorResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiErrorResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'error';
    yield serializers.serialize(
      object.error,
      specifiedType: const FullType(ApiErrorResponseError),
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
    ApiErrorResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiErrorResponseBuilder result,
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
            specifiedType: const FullType(ApiErrorResponseError),
          ) as ApiErrorResponseError;
          result.error.replace(valueDes);
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
  ApiErrorResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiErrorResponseBuilder();
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

