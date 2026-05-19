//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_brand_response.g.dart';

/// DeleteBrandResponse
///
/// Properties:
/// * [success] 
/// * [error] 
@BuiltValue()
abstract class DeleteBrandResponse implements Built<DeleteBrandResponse, DeleteBrandResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'error')
  String? get error;

  DeleteBrandResponse._();

  factory DeleteBrandResponse([void updates(DeleteBrandResponseBuilder b)]) = _$DeleteBrandResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteBrandResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteBrandResponse> get serializer => _$DeleteBrandResponseSerializer();
}

class _$DeleteBrandResponseSerializer implements PrimitiveSerializer<DeleteBrandResponse> {
  @override
  final Iterable<Type> types = const [DeleteBrandResponse, _$DeleteBrandResponse];

  @override
  final String wireName = r'DeleteBrandResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteBrandResponse object, {
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
    DeleteBrandResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteBrandResponseBuilder result,
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
  DeleteBrandResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteBrandResponseBuilder();
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

