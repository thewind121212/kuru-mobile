//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/product_variant_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_product_variants_response.g.dart';

/// GetProductVariantsResponse
///
/// Properties:
/// * [variants]
@BuiltValue()
abstract class GetProductVariantsResponse
    implements
        Built<GetProductVariantsResponse, GetProductVariantsResponseBuilder> {
  @BuiltValueField(wireName: r'variants')
  BuiltList<ProductVariantResponse>? get variants;

  GetProductVariantsResponse._();

  factory GetProductVariantsResponse([
    void updates(GetProductVariantsResponseBuilder b),
  ]) = _$GetProductVariantsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProductVariantsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProductVariantsResponse> get serializer =>
      _$GetProductVariantsResponseSerializer();
}

class _$GetProductVariantsResponseSerializer
    implements PrimitiveSerializer<GetProductVariantsResponse> {
  @override
  final Iterable<Type> types = const [
    GetProductVariantsResponse,
    _$GetProductVariantsResponse,
  ];

  @override
  final String wireName = r'GetProductVariantsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProductVariantsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.variants != null) {
      yield r'variants';
      yield serializers.serialize(
        object.variants,
        specifiedType: const FullType(BuiltList, [
          FullType(ProductVariantResponse),
        ]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetProductVariantsResponse object, {
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
    required GetProductVariantsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ProductVariantResponse),
                    ]),
                  )
                  as BuiltList<ProductVariantResponse>;
          result.variants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetProductVariantsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProductVariantsResponseBuilder();
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
