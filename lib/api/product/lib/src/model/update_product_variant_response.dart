//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_variant_response.g.dart';

/// UpdateProductVariantResponse
///
/// Properties:
/// * [success] 
/// * [error] 
@BuiltValue()
abstract class UpdateProductVariantResponse implements Built<UpdateProductVariantResponse, UpdateProductVariantResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  UpdateProductVariantResponse._();

  factory UpdateProductVariantResponse([void updates(UpdateProductVariantResponseBuilder b)]) = _$UpdateProductVariantResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductVariantResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductVariantResponse> get serializer => _$UpdateProductVariantResponseSerializer();
}

class _$UpdateProductVariantResponseSerializer implements PrimitiveSerializer<UpdateProductVariantResponse> {
  @override
  final Iterable<Type> types = const [UpdateProductVariantResponse, _$UpdateProductVariantResponse];

  @override
  final String wireName = r'UpdateProductVariantResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductVariantResponse object, {
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
    UpdateProductVariantResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProductVariantResponseBuilder result,
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
  UpdateProductVariantResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductVariantResponseBuilder();
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

