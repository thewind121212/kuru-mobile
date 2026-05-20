//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_product_variant_request.g.dart';

/// DeleteProductVariantRequest
///
/// Properties:
/// * [variantId] 
@BuiltValue()
abstract class DeleteProductVariantRequest implements Built<DeleteProductVariantRequest, DeleteProductVariantRequestBuilder> {
  @BuiltValueField(wireName: r'variantId')
  String get variantId;

  DeleteProductVariantRequest._();

  factory DeleteProductVariantRequest([void updates(DeleteProductVariantRequestBuilder b)]) = _$DeleteProductVariantRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteProductVariantRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteProductVariantRequest> get serializer => _$DeleteProductVariantRequestSerializer();
}

class _$DeleteProductVariantRequestSerializer implements PrimitiveSerializer<DeleteProductVariantRequest> {
  @override
  final Iterable<Type> types = const [DeleteProductVariantRequest, _$DeleteProductVariantRequest];

  @override
  final String wireName = r'DeleteProductVariantRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteProductVariantRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variantId';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteProductVariantRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteProductVariantRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variantId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteProductVariantRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteProductVariantRequestBuilder();
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

