//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/create_container_lot_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_container_lots_request.g.dart';

/// CreateContainerLotsRequest
///
/// Properties:
/// * [productId] 
/// * [lots] 
@BuiltValue()
abstract class CreateContainerLotsRequest implements Built<CreateContainerLotsRequest, CreateContainerLotsRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'lots')
  BuiltList<CreateContainerLotInput>? get lots;

  CreateContainerLotsRequest._();

  factory CreateContainerLotsRequest([void updates(CreateContainerLotsRequestBuilder b)]) = _$CreateContainerLotsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateContainerLotsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateContainerLotsRequest> get serializer => _$CreateContainerLotsRequestSerializer();
}

class _$CreateContainerLotsRequestSerializer implements PrimitiveSerializer<CreateContainerLotsRequest> {
  @override
  final Iterable<Type> types = const [CreateContainerLotsRequest, _$CreateContainerLotsRequest];

  @override
  final String wireName = r'CreateContainerLotsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateContainerLotsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    if (object.lots != null) {
      yield r'lots';
      yield serializers.serialize(
        object.lots,
        specifiedType: const FullType(BuiltList, [FullType(CreateContainerLotInput)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateContainerLotsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateContainerLotsRequestBuilder result,
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
        case r'lots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreateContainerLotInput)]),
          ) as BuiltList<CreateContainerLotInput>;
          result.lots.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateContainerLotsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateContainerLotsRequestBuilder();
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

