//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_brand_response.g.dart';

/// CreateBrandResponse
///
/// Properties:
/// * [brandId] 
@BuiltValue()
abstract class CreateBrandResponse implements Built<CreateBrandResponse, CreateBrandResponseBuilder> {
  @BuiltValueField(wireName: r'brandId')
  String? get brandId;

  CreateBrandResponse._();

  factory CreateBrandResponse([void updates(CreateBrandResponseBuilder b)]) = _$CreateBrandResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateBrandResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateBrandResponse> get serializer => _$CreateBrandResponseSerializer();
}

class _$CreateBrandResponseSerializer implements PrimitiveSerializer<CreateBrandResponse> {
  @override
  final Iterable<Type> types = const [CreateBrandResponse, _$CreateBrandResponse];

  @override
  final String wireName = r'CreateBrandResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateBrandResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.brandId != null) {
      yield r'brandId';
      yield serializers.serialize(
        object.brandId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateBrandResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateBrandResponseBuilder result,
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
  CreateBrandResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateBrandResponseBuilder();
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

