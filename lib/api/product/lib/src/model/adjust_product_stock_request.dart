//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/adjust_stock_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/manual_adjust_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjust_product_stock_request.g.dart';

/// AdjustProductStockRequest
///
/// Properties:
/// * [productId]
/// * [stocks]
/// * [reason]
/// * [note]
@BuiltValue()
abstract class AdjustProductStockRequest
    implements
        Built<AdjustProductStockRequest, AdjustProductStockRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'stocks')
  BuiltList<AdjustStockInput>? get stocks;

  @BuiltValueField(wireName: r'reason')
  ManualAdjustReason get reason;
  // enum reasonEnum {  STOCK_TAKE,  DAMAGE,  LOSS,  FOUND,  RECEIPT_CORRECTION,  OTHER,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdjustProductStockRequest._();

  factory AdjustProductStockRequest([
    void updates(AdjustProductStockRequestBuilder b),
  ]) = _$AdjustProductStockRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdjustProductStockRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdjustProductStockRequest> get serializer =>
      _$AdjustProductStockRequestSerializer();
}

class _$AdjustProductStockRequestSerializer
    implements PrimitiveSerializer<AdjustProductStockRequest> {
  @override
  final Iterable<Type> types = const [
    AdjustProductStockRequest,
    _$AdjustProductStockRequest,
  ];

  @override
  final String wireName = r'AdjustProductStockRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdjustProductStockRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    if (object.stocks != null) {
      yield r'stocks';
      yield serializers.serialize(
        object.stocks,
        specifiedType: const FullType(BuiltList, [FullType(AdjustStockInput)]),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ManualAdjustReason),
    );
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
    AdjustProductStockRequest object, {
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
    required AdjustProductStockRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.productId = valueDes;
          break;
        case r'stocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdjustStockInput),
                    ]),
                  )
                  as BuiltList<AdjustStockInput>;
          result.stocks.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ManualAdjustReason),
                  )
                  as ManualAdjustReason;
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
  AdjustProductStockRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdjustProductStockRequestBuilder();
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
