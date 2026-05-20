//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/product_variant_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_product_variants_response.g.dart';

/// SaveProductVariantsResponse
///
/// Properties:
/// * [success] 
/// * [error] 
/// * [variants] 
@BuiltValue()
abstract class SaveProductVariantsResponse implements Built<SaveProductVariantsResponse, SaveProductVariantsResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'variants')
  BuiltList<ProductVariantResponse>? get variants;

  SaveProductVariantsResponse._();

  factory SaveProductVariantsResponse([void updates(SaveProductVariantsResponseBuilder b)]) = _$SaveProductVariantsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveProductVariantsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveProductVariantsResponse> get serializer => _$SaveProductVariantsResponseSerializer();
}

class _$SaveProductVariantsResponseSerializer implements PrimitiveSerializer<SaveProductVariantsResponse> {
  @override
  final Iterable<Type> types = const [SaveProductVariantsResponse, _$SaveProductVariantsResponse];

  @override
  final String wireName = r'SaveProductVariantsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveProductVariantsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
    if (object.variants != null) {
      yield r'variants';
      yield serializers.serialize(
        object.variants,
        specifiedType: const FullType(BuiltList, [FullType(ProductVariantResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveProductVariantsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveProductVariantsResponseBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductVariantResponse)]),
          ) as BuiltList<ProductVariantResponse>;
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
  SaveProductVariantsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveProductVariantsResponseBuilder();
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

