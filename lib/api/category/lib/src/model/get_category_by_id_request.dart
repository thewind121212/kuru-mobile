//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_by_id_request.g.dart';

/// GetCategoryByIdRequest
///
/// Properties:
/// * [categoryId] 
@BuiltValue()
abstract class GetCategoryByIdRequest implements Built<GetCategoryByIdRequest, GetCategoryByIdRequestBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  GetCategoryByIdRequest._();

  factory GetCategoryByIdRequest([void updates(GetCategoryByIdRequestBuilder b)]) = _$GetCategoryByIdRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryByIdRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryByIdRequest> get serializer => _$GetCategoryByIdRequestSerializer();
}

class _$GetCategoryByIdRequestSerializer implements PrimitiveSerializer<GetCategoryByIdRequest> {
  @override
  final Iterable<Type> types = const [GetCategoryByIdRequest, _$GetCategoryByIdRequest];

  @override
  final String wireName = r'GetCategoryByIdRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryByIdRequest object, {
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
    GetCategoryByIdRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetCategoryByIdRequestBuilder result,
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
  GetCategoryByIdRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryByIdRequestBuilder();
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

