//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_container_lots_request.g.dart';

/// GetContainerLotsRequest
///
/// Properties:
/// * [productId]
/// * [variantId]
@BuiltValue()
abstract class GetContainerLotsRequest
    implements Built<GetContainerLotsRequest, GetContainerLotsRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'variantId')
  String? get variantId;

  GetContainerLotsRequest._();

  factory GetContainerLotsRequest([
    void updates(GetContainerLotsRequestBuilder b),
  ]) = _$GetContainerLotsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetContainerLotsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetContainerLotsRequest> get serializer =>
      _$GetContainerLotsRequestSerializer();
}

class _$GetContainerLotsRequestSerializer
    implements PrimitiveSerializer<GetContainerLotsRequest> {
  @override
  final Iterable<Type> types = const [
    GetContainerLotsRequest,
    _$GetContainerLotsRequest,
  ];

  @override
  final String wireName = r'GetContainerLotsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetContainerLotsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
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
    GetContainerLotsRequest object, {
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
    required GetContainerLotsRequestBuilder result,
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
        case r'variantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  GetContainerLotsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetContainerLotsRequestBuilder();
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
