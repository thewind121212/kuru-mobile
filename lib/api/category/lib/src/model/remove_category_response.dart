//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remove_category_response.g.dart';

/// RemoveCategoryResponse
///
/// Properties:
/// * [removedCount]
@BuiltValue()
abstract class RemoveCategoryResponse
    implements Built<RemoveCategoryResponse, RemoveCategoryResponseBuilder> {
  @BuiltValueField(wireName: r'removedCount')
  int get removedCount;

  RemoveCategoryResponse._();

  factory RemoveCategoryResponse([
    void updates(RemoveCategoryResponseBuilder b),
  ]) = _$RemoveCategoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemoveCategoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemoveCategoryResponse> get serializer =>
      _$RemoveCategoryResponseSerializer();
}

class _$RemoveCategoryResponseSerializer
    implements PrimitiveSerializer<RemoveCategoryResponse> {
  @override
  final Iterable<Type> types = const [
    RemoveCategoryResponse,
    _$RemoveCategoryResponse,
  ];

  @override
  final String wireName = r'RemoveCategoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemoveCategoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'removedCount';
    yield serializers.serialize(
      object.removedCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RemoveCategoryResponse object, {
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
    required RemoveCategoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'removedCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.removedCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RemoveCategoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemoveCategoryResponseBuilder();
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
