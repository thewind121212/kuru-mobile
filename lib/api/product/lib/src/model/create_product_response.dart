//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_response.g.dart';

/// CreateProductResponse
///
/// Properties:
/// * [productId]
@BuiltValue()
abstract class CreateProductResponse
    implements Built<CreateProductResponse, CreateProductResponseBuilder> {
  @BuiltValueField(wireName: r'productId')
  String? get productId;

  CreateProductResponse._();

  factory CreateProductResponse([
    void updates(CreateProductResponseBuilder b),
  ]) = _$CreateProductResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductResponse> get serializer =>
      _$CreateProductResponseSerializer();
}

class _$CreateProductResponseSerializer
    implements PrimitiveSerializer<CreateProductResponse> {
  @override
  final Iterable<Type> types = const [
    CreateProductResponse,
    _$CreateProductResponse,
  ];

  @override
  final String wireName = r'CreateProductResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.productId != null) {
      yield r'productId';
      yield serializers.serialize(
        object.productId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductResponse object, {
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
    required CreateProductResponseBuilder result,
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
  CreateProductResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductResponseBuilder();
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
