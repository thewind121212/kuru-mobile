//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_barcodes_response.g.dart';

/// UpdateProductBarcodesResponse
///
/// Properties:
/// * [success] 
/// * [error] 
@BuiltValue()
abstract class UpdateProductBarcodesResponse implements Built<UpdateProductBarcodesResponse, UpdateProductBarcodesResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  UpdateProductBarcodesResponse._();

  factory UpdateProductBarcodesResponse([void updates(UpdateProductBarcodesResponseBuilder b)]) = _$UpdateProductBarcodesResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductBarcodesResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductBarcodesResponse> get serializer => _$UpdateProductBarcodesResponseSerializer();
}

class _$UpdateProductBarcodesResponseSerializer implements PrimitiveSerializer<UpdateProductBarcodesResponse> {
  @override
  final Iterable<Type> types = const [UpdateProductBarcodesResponse, _$UpdateProductBarcodesResponse];

  @override
  final String wireName = r'UpdateProductBarcodesResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductBarcodesResponse object, {
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
    UpdateProductBarcodesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProductBarcodesResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  UpdateProductBarcodesResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductBarcodesResponseBuilder();
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

