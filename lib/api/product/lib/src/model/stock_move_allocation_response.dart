//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_move_allocation_response.g.dart';

/// StockMoveAllocationResponse
///
/// Properties:
/// * [warehouseId] 
/// * [lotId] 
/// * [qtyTaken] 
@BuiltValue()
abstract class StockMoveAllocationResponse implements Built<StockMoveAllocationResponse, StockMoveAllocationResponseBuilder> {
  @BuiltValueField(wireName: r'warehouseId')
  String get warehouseId;

  @BuiltValueField(wireName: r'lotId')
  String? get lotId;

  @BuiltValueField(wireName: r'qtyTaken')
  double get qtyTaken;

  StockMoveAllocationResponse._();

  factory StockMoveAllocationResponse([void updates(StockMoveAllocationResponseBuilder b)]) = _$StockMoveAllocationResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StockMoveAllocationResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StockMoveAllocationResponse> get serializer => _$StockMoveAllocationResponseSerializer();
}

class _$StockMoveAllocationResponseSerializer implements PrimitiveSerializer<StockMoveAllocationResponse> {
  @override
  final Iterable<Type> types = const [StockMoveAllocationResponse, _$StockMoveAllocationResponse];

  @override
  final String wireName = r'StockMoveAllocationResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StockMoveAllocationResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'warehouseId';
    yield serializers.serialize(
      object.warehouseId,
      specifiedType: const FullType(String),
    );
    if (object.lotId != null) {
      yield r'lotId';
      yield serializers.serialize(
        object.lotId,
        specifiedType: const FullType(String),
      );
    }
    yield r'qtyTaken';
    yield serializers.serialize(
      object.qtyTaken,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StockMoveAllocationResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StockMoveAllocationResponseBuilder result,
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
        case r'lotId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lotId = valueDes;
          break;
        case r'qtyTaken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.qtyTaken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StockMoveAllocationResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StockMoveAllocationResponseBuilder();
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

