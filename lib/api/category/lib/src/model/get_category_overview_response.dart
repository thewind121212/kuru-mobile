//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_category_api/src/model/category_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_overview_response.g.dart';

/// GetCategoryOverviewResponse
///
/// Properties:
/// * [categoryOverviews] 
@BuiltValue()
abstract class GetCategoryOverviewResponse implements Built<GetCategoryOverviewResponse, GetCategoryOverviewResponseBuilder> {
  @BuiltValueField(wireName: r'categoryOverviews')
  BuiltList<CategoryResponse>? get categoryOverviews;

  GetCategoryOverviewResponse._();

  factory GetCategoryOverviewResponse([void updates(GetCategoryOverviewResponseBuilder b)]) = _$GetCategoryOverviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryOverviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryOverviewResponse> get serializer => _$GetCategoryOverviewResponseSerializer();
}

class _$GetCategoryOverviewResponseSerializer implements PrimitiveSerializer<GetCategoryOverviewResponse> {
  @override
  final Iterable<Type> types = const [GetCategoryOverviewResponse, _$GetCategoryOverviewResponse];

  @override
  final String wireName = r'GetCategoryOverviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryOverviews != null) {
      yield r'categoryOverviews';
      yield serializers.serialize(
        object.categoryOverviews,
        specifiedType: const FullType(BuiltList, [FullType(CategoryResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCategoryOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetCategoryOverviewResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryOverviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CategoryResponse)]),
          ) as BuiltList<CategoryResponse>;
          result.categoryOverviews.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCategoryOverviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryOverviewResponseBuilder();
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

