//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/stock_move_allocation_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_move_history_response.g.dart';

/// StockMoveHistoryResponse
///
/// Properties:
/// * [id]
/// * [orgId]
/// * [productId]
/// * [type]
/// * [sourceType]
/// * [qtyBase]
/// * [uomLabel]
/// * [uomQty]
/// * [uomRatio]
/// * [createdAt]
/// * [actorUserId]
/// * [allocations]
/// * [variantId]
/// * [variantName]
/// * [warehouseName]
/// * [fromWarehouseName]
/// * [toWarehouseName]
/// * [reason]
/// * [note]
@BuiltValue()
abstract class StockMoveHistoryResponse
    implements
        Built<StockMoveHistoryResponse, StockMoveHistoryResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'sourceType')
  String get sourceType;

  @BuiltValueField(wireName: r'qtyBase')
  double get qtyBase;

  @BuiltValueField(wireName: r'uomLabel')
  String? get uomLabel;

  @BuiltValueField(wireName: r'uomQty')
  double? get uomQty;

  @BuiltValueField(wireName: r'uomRatio')
  double? get uomRatio;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'actorUserId')
  String get actorUserId;

  @BuiltValueField(wireName: r'allocations')
  BuiltList<StockMoveAllocationResponse>? get allocations;

  @BuiltValueField(wireName: r'variantId')
  String? get variantId;

  @BuiltValueField(wireName: r'variantName')
  String? get variantName;

  @BuiltValueField(wireName: r'warehouseName')
  String? get warehouseName;

  @BuiltValueField(wireName: r'fromWarehouseName')
  String? get fromWarehouseName;

  @BuiltValueField(wireName: r'toWarehouseName')
  String? get toWarehouseName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'note')
  String? get note;

  StockMoveHistoryResponse._();

  factory StockMoveHistoryResponse([
    void updates(StockMoveHistoryResponseBuilder b),
  ]) = _$StockMoveHistoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StockMoveHistoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StockMoveHistoryResponse> get serializer =>
      _$StockMoveHistoryResponseSerializer();
}

class _$StockMoveHistoryResponseSerializer
    implements PrimitiveSerializer<StockMoveHistoryResponse> {
  @override
  final Iterable<Type> types = const [
    StockMoveHistoryResponse,
    _$StockMoveHistoryResponse,
  ];

  @override
  final String wireName = r'StockMoveHistoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StockMoveHistoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'orgId';
    yield serializers.serialize(
      object.orgId,
      specifiedType: const FullType(String),
    );
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'sourceType';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
    yield r'qtyBase';
    yield serializers.serialize(
      object.qtyBase,
      specifiedType: const FullType(double),
    );
    if (object.uomLabel != null) {
      yield r'uomLabel';
      yield serializers.serialize(
        object.uomLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.uomQty != null) {
      yield r'uomQty';
      yield serializers.serialize(
        object.uomQty,
        specifiedType: const FullType(double),
      );
    }
    if (object.uomRatio != null) {
      yield r'uomRatio';
      yield serializers.serialize(
        object.uomRatio,
        specifiedType: const FullType(double),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorUserId';
    yield serializers.serialize(
      object.actorUserId,
      specifiedType: const FullType(String),
    );
    if (object.allocations != null) {
      yield r'allocations';
      yield serializers.serialize(
        object.allocations,
        specifiedType: const FullType(BuiltList, [
          FullType(StockMoveAllocationResponse),
        ]),
      );
    }
    if (object.variantId != null) {
      yield r'variantId';
      yield serializers.serialize(
        object.variantId,
        specifiedType: const FullType(String),
      );
    }
    if (object.variantName != null) {
      yield r'variantName';
      yield serializers.serialize(
        object.variantName,
        specifiedType: const FullType(String),
      );
    }
    if (object.warehouseName != null) {
      yield r'warehouseName';
      yield serializers.serialize(
        object.warehouseName,
        specifiedType: const FullType(String),
      );
    }
    if (object.fromWarehouseName != null) {
      yield r'fromWarehouseName';
      yield serializers.serialize(
        object.fromWarehouseName,
        specifiedType: const FullType(String),
      );
    }
    if (object.toWarehouseName != null) {
      yield r'toWarehouseName';
      yield serializers.serialize(
        object.toWarehouseName,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StockMoveHistoryResponse object, {
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
    required StockMoveHistoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'orgId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orgId = valueDes;
          break;
        case r'productId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.productId = valueDes;
          break;
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'sourceType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sourceType = valueDes;
          break;
        case r'qtyBase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.qtyBase = valueDes;
          break;
        case r'uomLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.uomLabel = valueDes;
          break;
        case r'uomQty':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.uomQty = valueDes;
          break;
        case r'uomRatio':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.uomRatio = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'actorUserId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.actorUserId = valueDes;
          break;
        case r'allocations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(StockMoveAllocationResponse),
                    ]),
                  )
                  as BuiltList<StockMoveAllocationResponse>;
          result.allocations.replace(valueDes);
          break;
        case r'variantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.variantId = valueDes;
          break;
        case r'variantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.variantName = valueDes;
          break;
        case r'warehouseName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.warehouseName = valueDes;
          break;
        case r'fromWarehouseName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fromWarehouseName = valueDes;
          break;
        case r'toWarehouseName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.toWarehouseName = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StockMoveHistoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StockMoveHistoryResponseBuilder();
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
