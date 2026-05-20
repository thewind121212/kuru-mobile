//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/variant_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_product_variants_request.g.dart';

/// SaveProductVariantsRequest
///
/// Properties:
/// * [productId] 
/// * [variants] 
/// * [deleteVariantIds] 
@BuiltValue()
abstract class SaveProductVariantsRequest implements Built<SaveProductVariantsRequest, SaveProductVariantsRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'variants')
  BuiltList<VariantInput>? get variants;

  @BuiltValueField(wireName: r'deleteVariantIds')
  BuiltList<String>? get deleteVariantIds;

  SaveProductVariantsRequest._();

  factory SaveProductVariantsRequest([void updates(SaveProductVariantsRequestBuilder b)]) = _$SaveProductVariantsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveProductVariantsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveProductVariantsRequest> get serializer => _$SaveProductVariantsRequestSerializer();
}

class _$SaveProductVariantsRequestSerializer implements PrimitiveSerializer<SaveProductVariantsRequest> {
  @override
  final Iterable<Type> types = const [SaveProductVariantsRequest, _$SaveProductVariantsRequest];

  @override
  final String wireName = r'SaveProductVariantsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveProductVariantsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    if (object.variants != null) {
      yield r'variants';
      yield serializers.serialize(
        object.variants,
        specifiedType: const FullType(BuiltList, [FullType(VariantInput)]),
      );
    }
    if (object.deleteVariantIds != null) {
      yield r'deleteVariantIds';
      yield serializers.serialize(
        object.deleteVariantIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveProductVariantsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveProductVariantsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productId = valueDes;
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VariantInput)]),
          ) as BuiltList<VariantInput>;
          result.variants.replace(valueDes);
          break;
        case r'deleteVariantIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.deleteVariantIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveProductVariantsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveProductVariantsRequestBuilder();
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

