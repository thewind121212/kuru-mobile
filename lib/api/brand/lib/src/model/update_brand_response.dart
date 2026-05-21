//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_brand_response.g.dart';

/// UpdateBrandResponse
///
/// Properties:
/// * [success]
/// * [error]
@BuiltValue()
abstract class UpdateBrandResponse
    implements Built<UpdateBrandResponse, UpdateBrandResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  UpdateBrandResponse._();

  factory UpdateBrandResponse([void updates(UpdateBrandResponseBuilder b)]) =
      _$UpdateBrandResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateBrandResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateBrandResponse> get serializer =>
      _$UpdateBrandResponseSerializer();
}

class _$UpdateBrandResponseSerializer
    implements PrimitiveSerializer<UpdateBrandResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateBrandResponse,
    _$UpdateBrandResponse,
  ];

  @override
  final String wireName = r'UpdateBrandResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateBrandResponse object, {
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
    UpdateBrandResponse object, {
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
    required UpdateBrandResponseBuilder result,
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
  UpdateBrandResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateBrandResponseBuilder();
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
