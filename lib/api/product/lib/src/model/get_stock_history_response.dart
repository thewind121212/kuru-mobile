//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/stock_move_history_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_stock_history_response.g.dart';

/// GetStockHistoryResponse
///
/// Properties:
/// * [moves]
/// * [page]
/// * [limit]
/// * [total]
@BuiltValue()
abstract class GetStockHistoryResponse
    implements Built<GetStockHistoryResponse, GetStockHistoryResponseBuilder> {
  @BuiltValueField(wireName: r'moves')
  BuiltList<StockMoveHistoryResponse>? get moves;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  @BuiltValueField(wireName: r'total')
  int get total;

  GetStockHistoryResponse._();

  factory GetStockHistoryResponse([
    void updates(GetStockHistoryResponseBuilder b),
  ]) = _$GetStockHistoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetStockHistoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetStockHistoryResponse> get serializer =>
      _$GetStockHistoryResponseSerializer();
}

class _$GetStockHistoryResponseSerializer
    implements PrimitiveSerializer<GetStockHistoryResponse> {
  @override
  final Iterable<Type> types = const [
    GetStockHistoryResponse,
    _$GetStockHistoryResponse,
  ];

  @override
  final String wireName = r'GetStockHistoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetStockHistoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.moves != null) {
      yield r'moves';
      yield serializers.serialize(
        object.moves,
        specifiedType: const FullType(BuiltList, [
          FullType(StockMoveHistoryResponse),
        ]),
      );
    }
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetStockHistoryResponse object, {
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
    required GetStockHistoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'moves':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(StockMoveHistoryResponse),
                    ]),
                  )
                  as BuiltList<StockMoveHistoryResponse>;
          result.moves.replace(valueDes);
          break;
        case r'page':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.page = valueDes;
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.limit = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetStockHistoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetStockHistoryResponseBuilder();
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
