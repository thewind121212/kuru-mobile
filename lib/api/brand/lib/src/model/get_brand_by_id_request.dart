//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_brand_by_id_request.g.dart';

/// GetBrandByIdRequest
///
/// Properties:
/// * [brandId] 
@BuiltValue()
abstract class GetBrandByIdRequest implements Built<GetBrandByIdRequest, GetBrandByIdRequestBuilder> {
  @BuiltValueField(wireName: r'brandId')
  String get brandId;

  GetBrandByIdRequest._();

  factory GetBrandByIdRequest([void updates(GetBrandByIdRequestBuilder b)]) = _$GetBrandByIdRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetBrandByIdRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetBrandByIdRequest> get serializer => _$GetBrandByIdRequestSerializer();
}

class _$GetBrandByIdRequestSerializer implements PrimitiveSerializer<GetBrandByIdRequest> {
  @override
  final Iterable<Type> types = const [GetBrandByIdRequest, _$GetBrandByIdRequest];

  @override
  final String wireName = r'GetBrandByIdRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetBrandByIdRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'brandId';
    yield serializers.serialize(
      object.brandId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetBrandByIdRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetBrandByIdRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'brandId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.brandId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetBrandByIdRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetBrandByIdRequestBuilder();
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

