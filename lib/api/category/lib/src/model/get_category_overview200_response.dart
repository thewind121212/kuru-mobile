//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_category_api/src/model/get_category_overview_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_category_overview200_response.g.dart';

/// GetCategoryOverview200Response
///
/// Properties:
/// * [success]
/// * [data]
/// * [timestamp]
@BuiltValue()
abstract class GetCategoryOverview200Response
    implements
        Built<
          GetCategoryOverview200Response,
          GetCategoryOverview200ResponseBuilder
        > {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  GetCategoryOverviewResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  GetCategoryOverview200Response._();

  factory GetCategoryOverview200Response([
    void updates(GetCategoryOverview200ResponseBuilder b),
  ]) = _$GetCategoryOverview200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCategoryOverview200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCategoryOverview200Response> get serializer =>
      _$GetCategoryOverview200ResponseSerializer();
}

class _$GetCategoryOverview200ResponseSerializer
    implements PrimitiveSerializer<GetCategoryOverview200Response> {
  @override
  final Iterable<Type> types = const [
    GetCategoryOverview200Response,
    _$GetCategoryOverview200Response,
  ];

  @override
  final String wireName = r'GetCategoryOverview200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCategoryOverview200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(GetCategoryOverviewResponse),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCategoryOverview200Response object, {
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
    required GetCategoryOverview200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.success = valueDes;
          break;
        case r'data':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(GetCategoryOverviewResponse),
                  )
                  as GetCategoryOverviewResponse;
          result.data.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCategoryOverview200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCategoryOverview200ResponseBuilder();
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
