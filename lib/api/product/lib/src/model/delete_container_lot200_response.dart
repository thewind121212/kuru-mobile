//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/delete_container_lot_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_container_lot200_response.g.dart';

/// DeleteContainerLot200Response
///
/// Properties:
/// * [success]
/// * [data]
/// * [timestamp]
@BuiltValue()
abstract class DeleteContainerLot200Response
    implements
        Built<
          DeleteContainerLot200Response,
          DeleteContainerLot200ResponseBuilder
        > {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  DeleteContainerLotResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  DeleteContainerLot200Response._();

  factory DeleteContainerLot200Response([
    void updates(DeleteContainerLot200ResponseBuilder b),
  ]) = _$DeleteContainerLot200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteContainerLot200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteContainerLot200Response> get serializer =>
      _$DeleteContainerLot200ResponseSerializer();
}

class _$DeleteContainerLot200ResponseSerializer
    implements PrimitiveSerializer<DeleteContainerLot200Response> {
  @override
  final Iterable<Type> types = const [
    DeleteContainerLot200Response,
    _$DeleteContainerLot200Response,
  ];

  @override
  final String wireName = r'DeleteContainerLot200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteContainerLot200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(DeleteContainerLotResponse),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteContainerLot200Response object, {
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
    required DeleteContainerLot200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.success = valueDes;
          break;
        case r'data':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DeleteContainerLotResponse),
                  )
                  as DeleteContainerLotResponse;
          result.data.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteContainerLot200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteContainerLot200ResponseBuilder();
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
