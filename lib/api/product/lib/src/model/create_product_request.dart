//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/create_product_stock_request.dart';
import 'package:kuru_product_api/src/model/create_product_barcode_request.dart';
import 'package:kuru_product_api/src/model/create_product_pack_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_request.g.dart';

/// CreateProductRequest
///
/// Properties:
/// * [categoryId] 
/// * [distributorId] 
/// * [brandId] 
/// * [name] 
/// * [description] 
/// * [imageUrl] 
/// * [status] 
/// * [baseUnitCode] 
/// * [baseUnitLabel] 
/// * [sellPrice] 
/// * [exportPrice] 
/// * [containerLabel] 
/// * [containerSize] 
/// * [packs] 
/// * [barcodes] 
/// * [initialStocks] 
/// * [demandStock] 
/// * [importPrice] 
@BuiltValue()
abstract class CreateProductRequest implements Built<CreateProductRequest, CreateProductRequestBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'distributorId')
  String? get distributorId;

  @BuiltValueField(wireName: r'brandId')
  String? get brandId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'baseUnitCode')
  String? get baseUnitCode;

  @BuiltValueField(wireName: r'baseUnitLabel')
  String? get baseUnitLabel;

  @BuiltValueField(wireName: r'sellPrice')
  double get sellPrice;

  @BuiltValueField(wireName: r'exportPrice')
  double? get exportPrice;

  @BuiltValueField(wireName: r'containerLabel')
  String? get containerLabel;

  @BuiltValueField(wireName: r'containerSize')
  double? get containerSize;

  @BuiltValueField(wireName: r'packs')
  BuiltList<CreateProductPackRequest>? get packs;

  @BuiltValueField(wireName: r'barcodes')
  BuiltList<CreateProductBarcodeRequest>? get barcodes;

  @BuiltValueField(wireName: r'initialStocks')
  BuiltList<CreateProductStockRequest>? get initialStocks;

  @BuiltValueField(wireName: r'demandStock')
  double get demandStock;

  @BuiltValueField(wireName: r'importPrice')
  double? get importPrice;

  CreateProductRequest._();

  factory CreateProductRequest([void updates(CreateProductRequestBuilder b)]) = _$CreateProductRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductRequest> get serializer => _$CreateProductRequestSerializer();
}

class _$CreateProductRequestSerializer implements PrimitiveSerializer<CreateProductRequest> {
  @override
  final Iterable<Type> types = const [CreateProductRequest, _$CreateProductRequest];

  @override
  final String wireName = r'CreateProductRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.brandId != null) {
      yield r'brandId';
      yield serializers.serialize(
        object.brandId,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
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
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.baseUnitCode != null) {
      yield r'baseUnitCode';
      yield serializers.serialize(
        object.baseUnitCode,
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
    yield r'sellPrice';
    yield serializers.serialize(
      object.sellPrice,
      specifiedType: const FullType(double),
    );
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
    if (object.packs != null) {
      yield r'packs';
      yield serializers.serialize(
        object.packs,
        specifiedType: const FullType(BuiltList, [FullType(CreateProductPackRequest)]),
      );
    }
    if (object.barcodes != null) {
      yield r'barcodes';
      yield serializers.serialize(
        object.barcodes,
        specifiedType: const FullType(BuiltList, [FullType(CreateProductBarcodeRequest)]),
      );
    }
    if (object.initialStocks != null) {
      yield r'initialStocks';
      yield serializers.serialize(
        object.initialStocks,
        specifiedType: const FullType(BuiltList, [FullType(CreateProductStockRequest)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateProductRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'brandId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.brandId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'baseUnitCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseUnitCode = valueDes;
          break;
        case r'baseUnitLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseUnitLabel = valueDes;
          break;
        case r'sellPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.sellPrice = valueDes;
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
        case r'packs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreateProductPackRequest)]),
          ) as BuiltList<CreateProductPackRequest>;
          result.packs.replace(valueDes);
          break;
        case r'barcodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreateProductBarcodeRequest)]),
          ) as BuiltList<CreateProductBarcodeRequest>;
          result.barcodes.replace(valueDes);
          break;
        case r'initialStocks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreateProductStockRequest)]),
          ) as BuiltList<CreateProductStockRequest>;
          result.initialStocks.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateProductRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductRequestBuilder();
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

