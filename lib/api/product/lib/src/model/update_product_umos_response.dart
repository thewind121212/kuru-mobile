//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_umos_response.g.dart';

/// UpdateProductUmosResponse
///
/// Properties:
/// * [success]
/// * [error]
@BuiltValue()
abstract class UpdateProductUmosResponse
    implements
        Built<UpdateProductUmosResponse, UpdateProductUmosResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  UpdateProductUmosResponse._();

  factory UpdateProductUmosResponse([
    void updates(UpdateProductUmosResponseBuilder b),
  ]) = _$UpdateProductUmosResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductUmosResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductUmosResponse> get serializer =>
      _$UpdateProductUmosResponseSerializer();
}

class _$UpdateProductUmosResponseSerializer
    implements PrimitiveSerializer<UpdateProductUmosResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateProductUmosResponse,
    _$UpdateProductUmosResponse,
  ];

  @override
  final String wireName = r'UpdateProductUmosResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductUmosResponse object, {
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
    UpdateProductUmosResponse object, {
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
    required UpdateProductUmosResponseBuilder result,
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
  UpdateProductUmosResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductUmosResponseBuilder();
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
