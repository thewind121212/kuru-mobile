//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_variant_request.g.dart';

/// UpdateProductVariantRequest
///
/// Properties:
/// * [variantId] 
/// * [name] 
/// * [sellPrice] 
/// * [exportPrice] 
/// * [importPrice] 
/// * [barcode] 
/// * [attributes] 
@BuiltValue()
abstract class UpdateProductVariantRequest implements Built<UpdateProductVariantRequest, UpdateProductVariantRequestBuilder> {
  @BuiltValueField(wireName: r'variantId')
  String get variantId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'sellPrice')
  double? get sellPrice;

  @BuiltValueField(wireName: r'exportPrice')
  double? get exportPrice;

  @BuiltValueField(wireName: r'importPrice')
  double? get importPrice;

  @BuiltValueField(wireName: r'barcode')
  String? get barcode;

  @BuiltValueField(wireName: r'attributes')
  BuiltMap<String, String> get attributes;

  UpdateProductVariantRequest._();

  factory UpdateProductVariantRequest([void updates(UpdateProductVariantRequestBuilder b)]) = _$UpdateProductVariantRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductVariantRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductVariantRequest> get serializer => _$UpdateProductVariantRequestSerializer();
}

class _$UpdateProductVariantRequestSerializer implements PrimitiveSerializer<UpdateProductVariantRequest> {
  @override
  final Iterable<Type> types = const [UpdateProductVariantRequest, _$UpdateProductVariantRequest];

  @override
  final String wireName = r'UpdateProductVariantRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductVariantRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variantId';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.sellPrice != null) {
      yield r'sellPrice';
      yield serializers.serialize(
        object.sellPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.exportPrice != null) {
      yield r'exportPrice';
      yield serializers.serialize(
        object.exportPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.importPrice != null) {
      yield r'importPrice';
      yield serializers.serialize(
        object.importPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.barcode != null) {
      yield r'barcode';
      yield serializers.serialize(
        object.barcode,
        specifiedType: const FullType(String),
      );
    }
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProductVariantRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProductVariantRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variantId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'importPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.importPrice = valueDes;
          break;
        case r'barcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.barcode = valueDes;
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.attributes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProductVariantRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductVariantRequestBuilder();
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

