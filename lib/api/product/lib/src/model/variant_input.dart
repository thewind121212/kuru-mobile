//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'variant_input.g.dart';

/// VariantInput
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [sellPrice] 
/// * [exportPrice] 
/// * [importPrice] 
/// * [attributes] 
/// * [barcode] 
/// * [imageUrl] 
/// * [attributeValueIds] 
@BuiltValue()
abstract class VariantInput implements Built<VariantInput, VariantInputBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sellPrice')
  double? get sellPrice;

  @BuiltValueField(wireName: r'exportPrice')
  double? get exportPrice;

  @BuiltValueField(wireName: r'importPrice')
  double? get importPrice;

  @BuiltValueField(wireName: r'attributes')
  BuiltMap<String, String> get attributes;

  @BuiltValueField(wireName: r'barcode')
  String? get barcode;

  @BuiltValueField(wireName: r'imageUrl')
  String? get imageUrl;

  @BuiltValueField(wireName: r'attributeValueIds')
  BuiltList<String>? get attributeValueIds;

  VariantInput._();

  factory VariantInput([void updates(VariantInputBuilder b)]) = _$VariantInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VariantInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VariantInput> get serializer => _$VariantInputSerializer();
}

class _$VariantInputSerializer implements PrimitiveSerializer<VariantInput> {
  @override
  final Iterable<Type> types = const [VariantInput, _$VariantInput];

  @override
  final String wireName = r'VariantInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VariantInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
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
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.barcode != null) {
      yield r'barcode';
      yield serializers.serialize(
        object.barcode,
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
    if (object.attributeValueIds != null) {
      yield r'attributeValueIds';
      yield serializers.serialize(
        object.attributeValueIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VariantInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VariantInputBuilder result,
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
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.attributes.replace(valueDes);
          break;
        case r'barcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.barcode = valueDes;
          break;
        case r'imageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageUrl = valueDes;
          break;
        case r'attributeValueIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.attributeValueIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VariantInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VariantInputBuilder();
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

