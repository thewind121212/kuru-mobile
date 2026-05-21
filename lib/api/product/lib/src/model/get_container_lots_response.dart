//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/container_lot_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_container_lots_response.g.dart';

/// GetContainerLotsResponse
///
/// Properties:
/// * [containerLots]
@BuiltValue()
abstract class GetContainerLotsResponse
    implements
        Built<GetContainerLotsResponse, GetContainerLotsResponseBuilder> {
  @BuiltValueField(wireName: r'containerLots')
  BuiltList<ContainerLotResponse>? get containerLots;

  GetContainerLotsResponse._();

  factory GetContainerLotsResponse([
    void updates(GetContainerLotsResponseBuilder b),
  ]) = _$GetContainerLotsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetContainerLotsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetContainerLotsResponse> get serializer =>
      _$GetContainerLotsResponseSerializer();
}

class _$GetContainerLotsResponseSerializer
    implements PrimitiveSerializer<GetContainerLotsResponse> {
  @override
  final Iterable<Type> types = const [
    GetContainerLotsResponse,
    _$GetContainerLotsResponse,
  ];

  @override
  final String wireName = r'GetContainerLotsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetContainerLotsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.containerLots != null) {
      yield r'containerLots';
      yield serializers.serialize(
        object.containerLots,
        specifiedType: const FullType(BuiltList, [
          FullType(ContainerLotResponse),
        ]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetContainerLotsResponse object, {
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
    required GetContainerLotsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'containerLots':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ContainerLotResponse),
                    ]),
                  )
                  as BuiltList<ContainerLotResponse>;
          result.containerLots.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetContainerLotsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetContainerLotsResponseBuilder();
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
