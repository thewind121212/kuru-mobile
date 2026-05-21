//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/product_barcode_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_uom_response.g.dart';

/// ProductUOMResponse
///
/// Properties:
/// * [id]
/// * [orgId]
/// * [productId]
/// * [name]
/// * [ratio]
/// * [sellPrice]
/// * [barcodes]
@BuiltValue()
abstract class ProductUOMResponse
    implements Built<ProductUOMResponse, ProductUOMResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'ratio')
  int get ratio;

  @BuiltValueField(wireName: r'sellPrice')
  double? get sellPrice;

  @BuiltValueField(wireName: r'barcodes')
  BuiltList<ProductBarcodeResponse>? get barcodes;

  ProductUOMResponse._();

  factory ProductUOMResponse([void updates(ProductUOMResponseBuilder b)]) =
      _$ProductUOMResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductUOMResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductUOMResponse> get serializer =>
      _$ProductUOMResponseSerializer();
}

class _$ProductUOMResponseSerializer
    implements PrimitiveSerializer<ProductUOMResponse> {
  @override
  final Iterable<Type> types = const [ProductUOMResponse, _$ProductUOMResponse];

  @override
  final String wireName = r'ProductUOMResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductUOMResponse object, {
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'ratio';
    yield serializers.serialize(
      object.ratio,
      specifiedType: const FullType(int),
    );
    if (object.sellPrice != null) {
      yield r'sellPrice';
      yield serializers.serialize(
        object.sellPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.barcodes != null) {
      yield r'barcodes';
      yield serializers.serialize(
        object.barcodes,
        specifiedType: const FullType(BuiltList, [
          FullType(ProductBarcodeResponse),
        ]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductUOMResponse object, {
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
    required ProductUOMResponseBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'ratio':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ratio = valueDes;
          break;
        case r'sellPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.sellPrice = valueDes;
          break;
        case r'barcodes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ProductBarcodeResponse),
                    ]),
                  )
                  as BuiltList<ProductBarcodeResponse>;
          result.barcodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductUOMResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductUOMResponseBuilder();
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
