//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/delete_lot_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_container_lot_request.g.dart';

/// DeleteContainerLotRequest
///
/// Properties:
/// * [containerLotId] 
/// * [reason] 
/// * [note] 
@BuiltValue()
abstract class DeleteContainerLotRequest implements Built<DeleteContainerLotRequest, DeleteContainerLotRequestBuilder> {
  @BuiltValueField(wireName: r'containerLotId')
  String get containerLotId;

  @BuiltValueField(wireName: r'reason')
  DeleteLotReason get reason;
  // enum reasonEnum {  LOSS,  STOCK_TAKE,  DAMAGE,  OTHER,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  DeleteContainerLotRequest._();

  factory DeleteContainerLotRequest([void updates(DeleteContainerLotRequestBuilder b)]) = _$DeleteContainerLotRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteContainerLotRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteContainerLotRequest> get serializer => _$DeleteContainerLotRequestSerializer();
}

class _$DeleteContainerLotRequestSerializer implements PrimitiveSerializer<DeleteContainerLotRequest> {
  @override
  final Iterable<Type> types = const [DeleteContainerLotRequest, _$DeleteContainerLotRequest];

  @override
  final String wireName = r'DeleteContainerLotRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteContainerLotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'containerLotId';
    yield serializers.serialize(
      object.containerLotId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(DeleteLotReason),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteContainerLotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteContainerLotRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'containerLotId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.containerLotId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeleteLotReason),
          ) as DeleteLotReason;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteContainerLotRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteContainerLotRequestBuilder();
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

