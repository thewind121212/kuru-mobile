//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_overview_response.g.dart';

/// ProductOverviewResponse
///
/// Properties:
/// * [id] 
/// * [orgId] 
/// * [name] 
/// * [imageUrl] 
/// * [status] 
/// * [baseUnitCode] 
/// * [sellPricePerUnit] 
/// * [currentStock] 
/// * [demandStock] 
/// * [category] 
/// * [variantCount] 
/// * [brandId] 
/// * [brandName] 
@BuiltValue()
abstract class ProductOverviewResponse implements Built<ProductOverviewResponse, ProductOverviewResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'imageUrl')
  String get imageUrl;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'baseUnitCode')
  String get baseUnitCode;

  @BuiltValueField(wireName: r'sellPricePerUnit')
  double get sellPricePerUnit;

  @BuiltValueField(wireName: r'currentStock')
  double get currentStock;

  @BuiltValueField(wireName: r'demandStock')
  double get demandStock;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'variantCount')
  int get variantCount;

  @BuiltValueField(wireName: r'brandId')
  String? get brandId;

  @BuiltValueField(wireName: r'brandName')
  String? get brandName;

  ProductOverviewResponse._();

  factory ProductOverviewResponse([void updates(ProductOverviewResponseBuilder b)]) = _$ProductOverviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductOverviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductOverviewResponse> get serializer => _$ProductOverviewResponseSerializer();
}

class _$ProductOverviewResponseSerializer implements PrimitiveSerializer<ProductOverviewResponse> {
  @override
  final Iterable<Type> types = const [ProductOverviewResponse, _$ProductOverviewResponse];

  @override
  final String wireName = r'ProductOverviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductOverviewResponse object, {
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'imageUrl';
    yield serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'baseUnitCode';
    yield serializers.serialize(
      object.baseUnitCode,
      specifiedType: const FullType(String),
    );
    yield r'sellPricePerUnit';
    yield serializers.serialize(
      object.sellPricePerUnit,
      specifiedType: const FullType(double),
    );
    yield r'currentStock';
    yield serializers.serialize(
      object.currentStock,
      specifiedType: const FullType(double),
    );
    yield r'demandStock';
    yield serializers.serialize(
      object.demandStock,
      specifiedType: const FullType(double),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'variantCount';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
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
    ProductOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductOverviewResponseBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'sellPricePerUnit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.sellPricePerUnit = valueDes;
          break;
        case r'currentStock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.currentStock = valueDes;
          break;
        case r'demandStock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.demandStock = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'variantCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
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
  ProductOverviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductOverviewResponseBuilder();
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

