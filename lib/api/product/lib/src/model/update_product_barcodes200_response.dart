//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/update_product_barcodes_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_barcodes200_response.g.dart';

/// UpdateProductBarcodes200Response
///
/// Properties:
/// * [success] 
/// * [data] 
/// * [timestamp] 
@BuiltValue()
abstract class UpdateProductBarcodes200Response implements Built<UpdateProductBarcodes200Response, UpdateProductBarcodes200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'data')
  UpdateProductBarcodesResponse get data;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  UpdateProductBarcodes200Response._();

  factory UpdateProductBarcodes200Response([void updates(UpdateProductBarcodes200ResponseBuilder b)]) = _$UpdateProductBarcodes200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductBarcodes200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductBarcodes200Response> get serializer => _$UpdateProductBarcodes200ResponseSerializer();
}

class _$UpdateProductBarcodes200ResponseSerializer implements PrimitiveSerializer<UpdateProductBarcodes200Response> {
  @override
  final Iterable<Type> types = const [UpdateProductBarcodes200Response, _$UpdateProductBarcodes200Response];

  @override
  final String wireName = r'UpdateProductBarcodes200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductBarcodes200Response object, {
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
      specifiedType: const FullType(UpdateProductBarcodesResponse),
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
    UpdateProductBarcodes200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProductBarcodes200ResponseBuilder result,
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
            specifiedType: const FullType(UpdateProductBarcodesResponse),
          ) as UpdateProductBarcodesResponse;
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
  UpdateProductBarcodes200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductBarcodes200ResponseBuilder();
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

