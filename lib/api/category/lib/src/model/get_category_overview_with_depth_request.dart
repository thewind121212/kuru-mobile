//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_overview_with_depth_request.g.dart';

/// GetCategoryOverviewWithDepthRequest
///
/// Properties:
/// * [depth]
@BuiltValue()
abstract class GetCategoryOverviewWithDepthRequest
    implements
        Built<
          GetCategoryOverviewWithDepthRequest,
          GetCategoryOverviewWithDepthRequestBuilder
        > {
  @BuiltValueField(wireName: r'depth')
  int get depth;

  GetCategoryOverviewWithDepthRequest._();

  factory GetCategoryOverviewWithDepthRequest([
    void updates(GetCategoryOverviewWithDepthRequestBuilder b),
  ]) = _$GetCategoryOverviewWithDepthRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryOverviewWithDepthRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryOverviewWithDepthRequest> get serializer =>
      _$GetCategoryOverviewWithDepthRequestSerializer();
}

class _$GetCategoryOverviewWithDepthRequestSerializer
    implements PrimitiveSerializer<GetCategoryOverviewWithDepthRequest> {
  @override
  final Iterable<Type> types = const [
    GetCategoryOverviewWithDepthRequest,
    _$GetCategoryOverviewWithDepthRequest,
  ];

  @override
  final String wireName = r'GetCategoryOverviewWithDepthRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryOverviewWithDepthRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'depth';
    yield serializers.serialize(
      object.depth,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCategoryOverviewWithDepthRequest object, {
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
    required GetCategoryOverviewWithDepthRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'depth':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.depth = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCategoryOverviewWithDepthRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryOverviewWithDepthRequestBuilder();
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
