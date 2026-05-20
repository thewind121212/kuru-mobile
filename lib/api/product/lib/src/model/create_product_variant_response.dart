//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_variant_response.g.dart';

/// CreateProductVariantResponse
///
/// Properties:
/// * [success] 
/// * [error] 
/// * [variantId] 
@BuiltValue()
abstract class CreateProductVariantResponse implements Built<CreateProductVariantResponse, CreateProductVariantResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'variantId')
  String? get variantId;

  CreateProductVariantResponse._();

  factory CreateProductVariantResponse([void updates(CreateProductVariantResponseBuilder b)]) = _$CreateProductVariantResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductVariantResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductVariantResponse> get serializer => _$CreateProductVariantResponseSerializer();
}

class _$CreateProductVariantResponseSerializer implements PrimitiveSerializer<CreateProductVariantResponse> {
  @override
  final Iterable<Type> types = const [CreateProductVariantResponse, _$CreateProductVariantResponse];

  @override
  final String wireName = r'CreateProductVariantResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductVariantResponse object, {
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
    if (object.variantId != null) {
      yield r'variantId';
      yield serializers.serialize(
        object.variantId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductVariantResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateProductVariantResponseBuilder result,
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
  CreateProductVariantResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductVariantResponseBuilder();
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

