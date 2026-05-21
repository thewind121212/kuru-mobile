//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_tree_request.g.dart';

/// GetCategoryTreeRequest
///
/// Properties:
/// * [categoryId]
@BuiltValue()
abstract class GetCategoryTreeRequest
    implements Built<GetCategoryTreeRequest, GetCategoryTreeRequestBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  GetCategoryTreeRequest._();

  factory GetCategoryTreeRequest([
    void updates(GetCategoryTreeRequestBuilder b),
  ]) = _$GetCategoryTreeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryTreeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryTreeRequest> get serializer =>
      _$GetCategoryTreeRequestSerializer();
}

class _$GetCategoryTreeRequestSerializer
    implements PrimitiveSerializer<GetCategoryTreeRequest> {
  @override
  final Iterable<Type> types = const [
    GetCategoryTreeRequest,
    _$GetCategoryTreeRequest,
  ];

  @override
  final String wireName = r'GetCategoryTreeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryTreeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCategoryTreeRequest object, {
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
    required GetCategoryTreeRequestBuilder result,
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
  GetCategoryTreeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryTreeRequestBuilder();
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
