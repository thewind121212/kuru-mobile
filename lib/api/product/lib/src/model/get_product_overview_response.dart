//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/product_overview_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_product_overview_response.g.dart';

/// GetProductOverviewResponse
///
/// Properties:
/// * [products]
/// * [maxSellPrice]
/// * [totalProducts]
/// * [totalValue]
/// * [totalVariants]
@BuiltValue()
abstract class GetProductOverviewResponse
    implements
        Built<GetProductOverviewResponse, GetProductOverviewResponseBuilder> {
  @BuiltValueField(wireName: r'products')
  BuiltList<ProductOverviewResponse>? get products;

  @BuiltValueField(wireName: r'maxSellPrice')
  double get maxSellPrice;

  @BuiltValueField(wireName: r'totalProducts')
  int get totalProducts;

  @BuiltValueField(wireName: r'totalValue')
  double get totalValue;

  @BuiltValueField(wireName: r'totalVariants')
  int get totalVariants;

  GetProductOverviewResponse._();

  factory GetProductOverviewResponse([
    void updates(GetProductOverviewResponseBuilder b),
  ]) = _$GetProductOverviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProductOverviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProductOverviewResponse> get serializer =>
      _$GetProductOverviewResponseSerializer();
}

class _$GetProductOverviewResponseSerializer
    implements PrimitiveSerializer<GetProductOverviewResponse> {
  @override
  final Iterable<Type> types = const [
    GetProductOverviewResponse,
    _$GetProductOverviewResponse,
  ];

  @override
  final String wireName = r'GetProductOverviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProductOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.products != null) {
      yield r'products';
      yield serializers.serialize(
        object.products,
        specifiedType: const FullType(BuiltList, [
          FullType(ProductOverviewResponse),
        ]),
      );
    }
    yield r'maxSellPrice';
    yield serializers.serialize(
      object.maxSellPrice,
      specifiedType: const FullType(double),
    );
    yield r'totalProducts';
    yield serializers.serialize(
      object.totalProducts,
      specifiedType: const FullType(int),
    );
    yield r'totalValue';
    yield serializers.serialize(
      object.totalValue,
      specifiedType: const FullType(double),
    );
    yield r'totalVariants';
    yield serializers.serialize(
      object.totalVariants,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetProductOverviewResponse object, {
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
    required GetProductOverviewResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'products':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ProductOverviewResponse),
                    ]),
                  )
                  as BuiltList<ProductOverviewResponse>;
          result.products.replace(valueDes);
          break;
        case r'maxSellPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.maxSellPrice = valueDes;
          break;
        case r'totalProducts':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.totalProducts = valueDes;
          break;
        case r'totalValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.totalValue = valueDes;
          break;
        case r'totalVariants':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.totalVariants = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetProductOverviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProductOverviewResponseBuilder();
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
