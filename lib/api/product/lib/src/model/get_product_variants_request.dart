//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_product_variants_request.g.dart';

/// GetProductVariantsRequest
///
/// Properties:
/// * [productId]
@BuiltValue()
abstract class GetProductVariantsRequest
    implements
        Built<GetProductVariantsRequest, GetProductVariantsRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  GetProductVariantsRequest._();

  factory GetProductVariantsRequest([
    void updates(GetProductVariantsRequestBuilder b),
  ]) = _$GetProductVariantsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProductVariantsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProductVariantsRequest> get serializer =>
      _$GetProductVariantsRequestSerializer();
}

class _$GetProductVariantsRequestSerializer
    implements PrimitiveSerializer<GetProductVariantsRequest> {
  @override
  final Iterable<Type> types = const [
    GetProductVariantsRequest,
    _$GetProductVariantsRequest,
  ];

  @override
  final String wireName = r'GetProductVariantsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProductVariantsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetProductVariantsRequest object, {
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
    required GetProductVariantsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.productId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetProductVariantsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProductVariantsRequestBuilder();
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
