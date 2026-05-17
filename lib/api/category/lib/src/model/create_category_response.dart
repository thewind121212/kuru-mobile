//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_category_response.g.dart';

/// CreateCategoryResponse
///
/// Properties:
/// * [categoryId] 
@BuiltValue()
abstract class CreateCategoryResponse implements Built<CreateCategoryResponse, CreateCategoryResponseBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  CreateCategoryResponse._();

  factory CreateCategoryResponse([void updates(CreateCategoryResponseBuilder b)]) = _$CreateCategoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCategoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCategoryResponse> get serializer => _$CreateCategoryResponseSerializer();
}

class _$CreateCategoryResponseSerializer implements PrimitiveSerializer<CreateCategoryResponse> {
  @override
  final Iterable<Type> types = const [CreateCategoryResponse, _$CreateCategoryResponse];

  @override
  final String wireName = r'CreateCategoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCategoryResponse object, {
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
    CreateCategoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateCategoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CreateCategoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCategoryResponseBuilder();
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

