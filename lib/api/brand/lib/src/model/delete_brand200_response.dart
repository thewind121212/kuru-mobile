//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_brand_api/src/model/delete_brand_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_brand200_response.g.dart';

/// DeleteBrand200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class DeleteBrand200Response implements Built<DeleteBrand200Response, DeleteBrand200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  DeleteBrandResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  DeleteBrand200Response._();

  factory DeleteBrand200Response([void updates(DeleteBrand200ResponseBuilder b)]) = _$DeleteBrand200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteBrand200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteBrand200Response> get serializer => _$DeleteBrand200ResponseSerializer();
}

class _$DeleteBrand200ResponseSerializer implements PrimitiveSerializer<DeleteBrand200Response> {
  @override
  final Iterable<Type> types = const [DeleteBrand200Response, _$DeleteBrand200Response];

  @override
  final String wireName = r'DeleteBrand200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteBrand200Response object, {
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
      specifiedType: const FullType(DeleteBrandResponse),
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
    DeleteBrand200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteBrand200ResponseBuilder result,
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
            specifiedType: const FullType(DeleteBrandResponse),
          ) as DeleteBrandResponse;
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
  DeleteBrand200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteBrand200ResponseBuilder();
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

