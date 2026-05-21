//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_category_response.g.dart';

/// UpdateCategoryResponse
///
/// Properties:
/// * [categoryId]
@BuiltValue()
abstract class UpdateCategoryResponse
    implements Built<UpdateCategoryResponse, UpdateCategoryResponseBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  UpdateCategoryResponse._();

  factory UpdateCategoryResponse([
    void updates(UpdateCategoryResponseBuilder b),
  ]) = _$UpdateCategoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCategoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCategoryResponse> get serializer =>
      _$UpdateCategoryResponseSerializer();
}

class _$UpdateCategoryResponseSerializer
    implements PrimitiveSerializer<UpdateCategoryResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateCategoryResponse,
    _$UpdateCategoryResponse,
  ];

  @override
  final String wireName = r'UpdateCategoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCategoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCategoryResponse object, {
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
    required UpdateCategoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCategoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCategoryResponseBuilder();
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
