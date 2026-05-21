//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remove_category_request.g.dart';

/// RemoveCategoryRequest
///
/// Properties:
/// * [categoryIds]
@BuiltValue()
abstract class RemoveCategoryRequest
    implements Built<RemoveCategoryRequest, RemoveCategoryRequestBuilder> {
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String>? get categoryIds;

  RemoveCategoryRequest._();

  factory RemoveCategoryRequest([
    void updates(RemoveCategoryRequestBuilder b),
  ]) = _$RemoveCategoryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemoveCategoryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemoveCategoryRequest> get serializer =>
      _$RemoveCategoryRequestSerializer();
}

class _$RemoveCategoryRequestSerializer
    implements PrimitiveSerializer<RemoveCategoryRequest> {
  @override
  final Iterable<Type> types = const [
    RemoveCategoryRequest,
    _$RemoveCategoryRequest,
  ];

  @override
  final String wireName = r'RemoveCategoryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemoveCategoryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryIds != null) {
      yield r'categoryIds';
      yield serializers.serialize(
        object.categoryIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RemoveCategoryRequest object, {
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
    required RemoveCategoryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RemoveCategoryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemoveCategoryRequestBuilder();
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
