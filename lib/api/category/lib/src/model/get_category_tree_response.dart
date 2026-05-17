//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_category_api/src/model/category_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_tree_response.g.dart';

/// GetCategoryTreeResponse
///
/// Properties:
/// * [categoryTree] 
@BuiltValue()
abstract class GetCategoryTreeResponse implements Built<GetCategoryTreeResponse, GetCategoryTreeResponseBuilder> {
  @BuiltValueField(wireName: r'categoryTree')
  BuiltList<CategoryResponse>? get categoryTree;

  GetCategoryTreeResponse._();

  factory GetCategoryTreeResponse([void updates(GetCategoryTreeResponseBuilder b)]) = _$GetCategoryTreeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryTreeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryTreeResponse> get serializer => _$GetCategoryTreeResponseSerializer();
}

class _$GetCategoryTreeResponseSerializer implements PrimitiveSerializer<GetCategoryTreeResponse> {
  @override
  final Iterable<Type> types = const [GetCategoryTreeResponse, _$GetCategoryTreeResponse];

  @override
  final String wireName = r'GetCategoryTreeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryTreeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryTree != null) {
      yield r'categoryTree';
      yield serializers.serialize(
        object.categoryTree,
        specifiedType: const FullType(BuiltList, [FullType(CategoryResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCategoryTreeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetCategoryTreeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryTree':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CategoryResponse)]),
          ) as BuiltList<CategoryResponse>;
          result.categoryTree.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCategoryTreeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryTreeResponseBuilder();
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

