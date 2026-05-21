//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_category_api/src/model/remove_category_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remove_category200_response.g.dart';

/// RemoveCategory200Response
///
/// Properties:
/// * [success]
/// * [data]
/// * [timestamp]
@BuiltValue()
abstract class RemoveCategory200Response
    implements
        Built<RemoveCategory200Response, RemoveCategory200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  RemoveCategoryResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  RemoveCategory200Response._();

  factory RemoveCategory200Response([
    void updates(RemoveCategory200ResponseBuilder b),
  ]) = _$RemoveCategory200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemoveCategory200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemoveCategory200Response> get serializer =>
      _$RemoveCategory200ResponseSerializer();
}

class _$RemoveCategory200ResponseSerializer
    implements PrimitiveSerializer<RemoveCategory200Response> {
  @override
  final Iterable<Type> types = const [
    RemoveCategory200Response,
    _$RemoveCategory200Response,
  ];

  @override
  final String wireName = r'RemoveCategory200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemoveCategory200Response object, {
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
      specifiedType: const FullType(RemoveCategoryResponse),
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
    RemoveCategory200Response object, {
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
    required RemoveCategory200ResponseBuilder result,
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
                    specifiedType: const FullType(RemoveCategoryResponse),
                  )
                  as RemoveCategoryResponse;
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
  RemoveCategory200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemoveCategory200ResponseBuilder();
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
