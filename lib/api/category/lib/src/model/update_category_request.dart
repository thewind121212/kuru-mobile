//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_category_api/src/model/create_category_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_category_request.g.dart';

/// UpdateCategoryRequest
///
/// Properties:
/// * [categoryId]
/// * [categoryUpdate]
@BuiltValue()
abstract class UpdateCategoryRequest
    implements Built<UpdateCategoryRequest, UpdateCategoryRequestBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'categoryUpdate')
  CreateCategoryRequest get categoryUpdate;

  UpdateCategoryRequest._();

  factory UpdateCategoryRequest([
    void updates(UpdateCategoryRequestBuilder b),
  ]) = _$UpdateCategoryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCategoryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCategoryRequest> get serializer =>
      _$UpdateCategoryRequestSerializer();
}

class _$UpdateCategoryRequestSerializer
    implements PrimitiveSerializer<UpdateCategoryRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateCategoryRequest,
    _$UpdateCategoryRequest,
  ];

  @override
  final String wireName = r'UpdateCategoryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCategoryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'categoryUpdate';
    yield serializers.serialize(
      object.categoryUpdate,
      specifiedType: const FullType(CreateCategoryRequest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCategoryRequest object, {
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
    required UpdateCategoryRequestBuilder result,
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
        case r'categoryUpdate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CreateCategoryRequest),
                  )
                  as CreateCategoryRequest;
          result.categoryUpdate.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCategoryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCategoryRequestBuilder();
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
