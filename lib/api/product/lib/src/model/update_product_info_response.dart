//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_info_response.g.dart';

/// UpdateProductInfoResponse
///
/// Properties:
/// * [success]
/// * [error]
@BuiltValue()
abstract class UpdateProductInfoResponse
    implements
        Built<UpdateProductInfoResponse, UpdateProductInfoResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  UpdateProductInfoResponse._();

  factory UpdateProductInfoResponse([
    void updates(UpdateProductInfoResponseBuilder b),
  ]) = _$UpdateProductInfoResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductInfoResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductInfoResponse> get serializer =>
      _$UpdateProductInfoResponseSerializer();
}

class _$UpdateProductInfoResponseSerializer
    implements PrimitiveSerializer<UpdateProductInfoResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateProductInfoResponse,
    _$UpdateProductInfoResponse,
  ];

  @override
  final String wireName = r'UpdateProductInfoResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductInfoResponse object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProductInfoResponse object, {
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
    required UpdateProductInfoResponseBuilder result,
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
        case r'error':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProductInfoResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductInfoResponseBuilder();
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
