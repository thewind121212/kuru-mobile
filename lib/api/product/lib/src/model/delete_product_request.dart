//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_product_request.g.dart';

/// DeleteProductRequest
///
/// Properties:
/// * [productId]
@BuiltValue()
abstract class DeleteProductRequest
    implements Built<DeleteProductRequest, DeleteProductRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  DeleteProductRequest._();

  factory DeleteProductRequest([void updates(DeleteProductRequestBuilder b)]) =
      _$DeleteProductRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteProductRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteProductRequest> get serializer =>
      _$DeleteProductRequestSerializer();
}

class _$DeleteProductRequestSerializer
    implements PrimitiveSerializer<DeleteProductRequest> {
  @override
  final Iterable<Type> types = const [
    DeleteProductRequest,
    _$DeleteProductRequest,
  ];

  @override
  final String wireName = r'DeleteProductRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteProductRequest object, {
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
    DeleteProductRequest object, {
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
    required DeleteProductRequestBuilder result,
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
  DeleteProductRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteProductRequestBuilder();
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
