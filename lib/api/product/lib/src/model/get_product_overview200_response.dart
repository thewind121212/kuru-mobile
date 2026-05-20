//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/get_product_overview_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_product_overview200_response.g.dart';

/// GetProductOverview200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class GetProductOverview200Response implements Built<GetProductOverview200Response, GetProductOverview200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  GetProductOverviewResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  GetProductOverview200Response._();

  factory GetProductOverview200Response([void updates(GetProductOverview200ResponseBuilder b)]) = _$GetProductOverview200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProductOverview200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProductOverview200Response> get serializer => _$GetProductOverview200ResponseSerializer();
}

class _$GetProductOverview200ResponseSerializer implements PrimitiveSerializer<GetProductOverview200Response> {
  @override
  final Iterable<Type> types = const [GetProductOverview200Response, _$GetProductOverview200Response];

  @override
  final String wireName = r'GetProductOverview200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProductOverview200Response object, {
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
      specifiedType: const FullType(GetProductOverviewResponse),
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
    GetProductOverview200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetProductOverview200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GetProductOverviewResponse),
          ) as GetProductOverviewResponse;
          result.data.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  GetProductOverview200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProductOverview200ResponseBuilder();
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

