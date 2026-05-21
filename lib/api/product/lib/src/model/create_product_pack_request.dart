//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/create_product_barcode_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_pack_request.g.dart';

/// CreateProductPackRequest
///
/// Properties:
/// * [name]
/// * [multiplier]
/// * [barcodes]
/// * [sellPrice]
@BuiltValue()
abstract class CreateProductPackRequest
    implements
        Built<CreateProductPackRequest, CreateProductPackRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'multiplier')
  int get multiplier;

  @BuiltValueField(wireName: r'barcodes')
  BuiltList<CreateProductBarcodeRequest>? get barcodes;

  @BuiltValueField(wireName: r'sellPrice')
  double? get sellPrice;

  CreateProductPackRequest._();

  factory CreateProductPackRequest([
    void updates(CreateProductPackRequestBuilder b),
  ]) = _$CreateProductPackRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductPackRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductPackRequest> get serializer =>
      _$CreateProductPackRequestSerializer();
}

class _$CreateProductPackRequestSerializer
    implements PrimitiveSerializer<CreateProductPackRequest> {
  @override
  final Iterable<Type> types = const [
    CreateProductPackRequest,
    _$CreateProductPackRequest,
  ];

  @override
  final String wireName = r'CreateProductPackRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductPackRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'multiplier';
    yield serializers.serialize(
      object.multiplier,
      specifiedType: const FullType(int),
    );
    if (object.barcodes != null) {
      yield r'barcodes';
      yield serializers.serialize(
        object.barcodes,
        specifiedType: const FullType(BuiltList, [
          FullType(CreateProductBarcodeRequest),
        ]),
      );
    }
    if (object.sellPrice != null) {
      yield r'sellPrice';
      yield serializers.serialize(
        object.sellPrice,
        specifiedType: const FullType(double),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductPackRequest object, {
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
    required CreateProductPackRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'multiplier':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.multiplier = valueDes;
          break;
        case r'barcodes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CreateProductBarcodeRequest),
                    ]),
                  )
                  as BuiltList<CreateProductBarcodeRequest>;
          result.barcodes.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateProductPackRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductPackRequestBuilder();
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
