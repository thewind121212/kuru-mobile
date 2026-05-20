//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_stock_request.g.dart';

/// CreateProductStockRequest
///
/// Properties:
/// * [warehouseId] 
/// * [qty] 
@BuiltValue()
abstract class CreateProductStockRequest implements Built<CreateProductStockRequest, CreateProductStockRequestBuilder> {
  @BuiltValueField(wireName: r'warehouseId')
  String get warehouseId;

  @BuiltValueField(wireName: r'qty')
  double get qty;

  CreateProductStockRequest._();

  factory CreateProductStockRequest([void updates(CreateProductStockRequestBuilder b)]) = _$CreateProductStockRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductStockRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductStockRequest> get serializer => _$CreateProductStockRequestSerializer();
}

class _$CreateProductStockRequestSerializer implements PrimitiveSerializer<CreateProductStockRequest> {
  @override
  final Iterable<Type> types = const [CreateProductStockRequest, _$CreateProductStockRequest];

  @override
  final String wireName = r'CreateProductStockRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductStockRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'warehouseId';
    yield serializers.serialize(
      object.warehouseId,
      specifiedType: const FullType(String),
    );
    yield r'qty';
    yield serializers.serialize(
      object.qty,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductStockRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateProductStockRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'warehouseId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.warehouseId = valueDes;
          break;
        case r'qty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.qty = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateProductStockRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductStockRequestBuilder();
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

