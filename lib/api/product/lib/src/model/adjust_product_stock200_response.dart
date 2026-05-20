//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/adjust_product_stock_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjust_product_stock200_response.g.dart';

/// AdjustProductStock200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class AdjustProductStock200Response implements Built<AdjustProductStock200Response, AdjustProductStock200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  AdjustProductStockResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  AdjustProductStock200Response._();

  factory AdjustProductStock200Response([void updates(AdjustProductStock200ResponseBuilder b)]) = _$AdjustProductStock200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdjustProductStock200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdjustProductStock200Response> get serializer => _$AdjustProductStock200ResponseSerializer();
}

class _$AdjustProductStock200ResponseSerializer implements PrimitiveSerializer<AdjustProductStock200Response> {
  @override
  final Iterable<Type> types = const [AdjustProductStock200Response, _$AdjustProductStock200Response];

  @override
  final String wireName = r'AdjustProductStock200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdjustProductStock200Response object, {
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
      specifiedType: const FullType(AdjustProductStockResponse),
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
    AdjustProductStock200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdjustProductStock200ResponseBuilder result,
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
            specifiedType: const FullType(AdjustProductStockResponse),
          ) as AdjustProductStockResponse;
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
  AdjustProductStock200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdjustProductStock200ResponseBuilder();
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

