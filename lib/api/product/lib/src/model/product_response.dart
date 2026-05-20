//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_product_api/src/model/product_variant_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/product_barcode_response.dart';
import 'package:kuru_product_api/src/model/product_stock_response.dart';
import 'package:kuru_product_api/src/model/product_uom_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_response.g.dart';

/// ProductResponse
///
/// Properties:
/// * [id] 
/// * [orgId] 
/// * [categoryId] 
/// * [distributorId] 
/// * [description] 
/// * [imageUrl] 
/// * [name] 
/// * [status] 
/// * [isDelete] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [baseUnitCode] 
/// * [sellPrice] 
/// * [umos] 
/// * [barcodes] 
/// * [internalBarcode] 
/// * [baseUnitLabel] 
/// * [exportPrice] 
/// * [containerLabel] 
/// * [containerSize] 
/// * [stocks] 
/// * [demandStock] 
/// * [importPrice] 
/// * [variants] 
/// * [avgCost] 
/// * [totalCostValue] 
/// * [totalQtyImported] 
/// * [brandId] 
/// * [brandName] 
@BuiltValue()
abstract class ProductResponse implements Built<ProductResponse, ProductResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'distributorId')
  String? get distributorId;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'isDelete')
  bool get isDelete;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'baseUnitCode')
  String get baseUnitCode;

  @BuiltValueField(wireName: r'sellPrice')
  double get sellPrice;

  @BuiltValueField(wireName: r'umos')
  BuiltList<ProductUOMResponse>? get umos;

  @BuiltValueField(wireName: r'barcodes')
  BuiltList<ProductBarcodeResponse>? get barcodes;

  @BuiltValueField(wireName: r'internalBarcode')
  String? get internalBarcode;

  @BuiltValueField(wireName: r'baseUnitLabel')
  String? get baseUnitLabel;

  @BuiltValueField(wireName: r'exportPrice')
  double? get exportPrice;

  @BuiltValueField(wireName: r'containerLabel')
  String? get containerLabel;

  @BuiltValueField(wireName: r'containerSize')
  double? get containerSize;

  @BuiltValueField(wireName: r'stocks')
  BuiltList<ProductStockResponse>? get stocks;

  @BuiltValueField(wireName: r'demandStock')
  double get demandStock;

  @BuiltValueField(wireName: r'importPrice')
  double? get importPrice;

  @BuiltValueField(wireName: r'variants')
  BuiltList<ProductVariantResponse>? get variants;

  @BuiltValueField(wireName: r'avgCost')
  double get avgCost;

  @BuiltValueField(wireName: r'totalCostValue')
  double get totalCostValue;

  @BuiltValueField(wireName: r'totalQtyImported')
  double get totalQtyImported;

  @BuiltValueField(wireName: r'brandId')
  String? get brandId;

  @BuiltValueField(wireName: r'brandName')
  String? get brandName;

  ProductResponse._();

  factory ProductResponse([void updates(ProductResponseBuilder b)]) = _$ProductResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductResponse> get serializer => _$ProductResponseSerializer();
}

class _$ProductResponseSerializer implements PrimitiveSerializer<ProductResponse> {
  @override
  final Iterable<Type> types = const [ProductResponse, _$ProductResponse];

  @override
  final String wireName = r'ProductResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductResponse object, {
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
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.distributorId != null) {
      yield r'distributorId';
      yield serializers.serialize(
        object.distributorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.imageUrl != null) {
      yield r'imageUrl';
      yield serializers.serialize(
        object.imageUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'isDelete';
    yield serializers.serialize(
      object.isDelete,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'baseUnitCode';
    yield serializers.serialize(
      object.baseUnitCode,
      specifiedType: const FullType(String),
    );
    yield r'sellPrice';
    yield serializers.serialize(
      object.sellPrice,
      specifiedType: const FullType(double),
    );
    if (object.umos != null) {
      yield r'umos';
      yield serializers.serialize(
        object.umos,
        specifiedType: const FullType(BuiltList, [FullType(ProductUOMResponse)]),
      );
    }
    if (object.barcodes != null) {
      yield r'barcodes';
      yield serializers.serialize(
        object.barcodes,
        specifiedType: const FullType(BuiltList, [FullType(ProductBarcodeResponse)]),
      );
    }
    if (object.internalBarcode != null) {
      yield r'internalBarcode';
      yield serializers.serialize(
        object.internalBarcode,
        specifiedType: const FullType(String),
      );
    }
    if (object.baseUnitLabel != null) {
      yield r'baseUnitLabel';
      yield serializers.serialize(
        object.baseUnitLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.exportPrice != null) {
      yield r'exportPrice';
      yield serializers.serialize(
        object.exportPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.containerLabel != null) {
      yield r'containerLabel';
      yield serializers.serialize(
        object.containerLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.containerSize != null) {
      yield r'containerSize';
      yield serializers.serialize(
        object.containerSize,
        specifiedType: const FullType(double),
      );
    }
    if (object.stocks != null) {
      yield r'stocks';
      yield serializers.serialize(
        object.stocks,
        specifiedType: const FullType(BuiltList, [FullType(ProductStockResponse)]),
      );
    }
    yield r'demandStock';
    yield serializers.serialize(
      object.demandStock,
      specifiedType: const FullType(double),
    );
    if (object.importPrice != null) {
      yield r'importPrice';
      yield serializers.serialize(
        object.importPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.variants != null) {
      yield r'variants';
      yield serializers.serialize(
        object.variants,
        specifiedType: const FullType(BuiltList, [FullType(ProductVariantResponse)]),
      );
    }
    yield r'avgCost';
    yield serializers.serialize(
      object.avgCost,
      specifiedType: const FullType(double),
    );
    yield r'totalCostValue';
    yield serializers.serialize(
      object.totalCostValue,
      specifiedType: const FullType(double),
    );
    yield r'totalQtyImported';
    yield serializers.serialize(
      object.totalQtyImported,
      specifiedType: const FullType(double),
    );
    if (object.brandId != null) {
      yield r'brandId';
      yield serializers.serialize(
        object.brandId,
        specifiedType: const FullType(String),
      );
    }
    if (object.brandName != null) {
      yield r'brandName';
      yield serializers.serialize(
        object.brandName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'orgId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orgId = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'distributorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.distributorId = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'imageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageUrl = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'isDelete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDelete = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'baseUnitCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseUnitCode = valueDes;
          break;
        case r'sellPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.sellPrice = valueDes;
          break;
        case r'umos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductUOMResponse)]),
          ) as BuiltList<ProductUOMResponse>;
          result.umos.replace(valueDes);
          break;
        case r'barcodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductBarcodeResponse)]),
          ) as BuiltList<ProductBarcodeResponse>;
          result.barcodes.replace(valueDes);
          break;
        case r'internalBarcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.internalBarcode = valueDes;
          break;
        case r'baseUnitLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseUnitLabel = valueDes;
          break;
        case r'exportPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.exportPrice = valueDes;
          break;
        case r'containerLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.containerLabel = valueDes;
          break;
        case r'containerSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.containerSize = valueDes;
          break;
        case r'stocks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductStockResponse)]),
          ) as BuiltList<ProductStockResponse>;
          result.stocks.replace(valueDes);
          break;
        case r'demandStock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.demandStock = valueDes;
          break;
        case r'importPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.importPrice = valueDes;
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductVariantResponse)]),
          ) as BuiltList<ProductVariantResponse>;
          result.variants.replace(valueDes);
          break;
        case r'avgCost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.avgCost = valueDes;
          break;
        case r'totalCostValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.totalCostValue = valueDes;
          break;
        case r'totalQtyImported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.totalQtyImported = valueDes;
          break;
        case r'brandId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.brandId = valueDes;
          break;
        case r'brandName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.brandName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductResponseBuilder();
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

