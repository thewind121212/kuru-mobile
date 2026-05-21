//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/upsert_umo_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_umos_request.g.dart';

/// UpdateProductUmosRequest
///
/// Properties:
/// * [productId]
/// * [upsertUmos]
/// * [removeUmoIds]
@BuiltValue()
abstract class UpdateProductUmosRequest
    implements
        Built<UpdateProductUmosRequest, UpdateProductUmosRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'upsertUmos')
  BuiltList<UpsertUmoInput>? get upsertUmos;

  @BuiltValueField(wireName: r'removeUmoIds')
  BuiltList<String>? get removeUmoIds;

  UpdateProductUmosRequest._();

  factory UpdateProductUmosRequest([
    void updates(UpdateProductUmosRequestBuilder b),
  ]) = _$UpdateProductUmosRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductUmosRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductUmosRequest> get serializer =>
      _$UpdateProductUmosRequestSerializer();
}

class _$UpdateProductUmosRequestSerializer
    implements PrimitiveSerializer<UpdateProductUmosRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateProductUmosRequest,
    _$UpdateProductUmosRequest,
  ];

  @override
  final String wireName = r'UpdateProductUmosRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductUmosRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    if (object.upsertUmos != null) {
      yield r'upsertUmos';
      yield serializers.serialize(
        object.upsertUmos,
        specifiedType: const FullType(BuiltList, [FullType(UpsertUmoInput)]),
      );
    }
    if (object.removeUmoIds != null) {
      yield r'removeUmoIds';
      yield serializers.serialize(
        object.removeUmoIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProductUmosRequest object, {
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
    required UpdateProductUmosRequestBuilder result,
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
        case r'upsertUmos':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(UpsertUmoInput),
                    ]),
                  )
                  as BuiltList<UpsertUmoInput>;
          result.upsertUmos.replace(valueDes);
          break;
        case r'removeUmoIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.removeUmoIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProductUmosRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductUmosRequestBuilder();
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
