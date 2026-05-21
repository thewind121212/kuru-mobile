//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_product_barcode_request.g.dart';

/// CreateProductBarcodeRequest
///
/// Properties:
/// * [value]
/// * [isActive]
@BuiltValue()
abstract class CreateProductBarcodeRequest
    implements
        Built<CreateProductBarcodeRequest, CreateProductBarcodeRequestBuilder> {
  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  CreateProductBarcodeRequest._();

  factory CreateProductBarcodeRequest([
    void updates(CreateProductBarcodeRequestBuilder b),
  ]) = _$CreateProductBarcodeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateProductBarcodeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateProductBarcodeRequest> get serializer =>
      _$CreateProductBarcodeRequestSerializer();
}

class _$CreateProductBarcodeRequestSerializer
    implements PrimitiveSerializer<CreateProductBarcodeRequest> {
  @override
  final Iterable<Type> types = const [
    CreateProductBarcodeRequest,
    _$CreateProductBarcodeRequest,
  ];

  @override
  final String wireName = r'CreateProductBarcodeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateProductBarcodeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateProductBarcodeRequest object, {
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
    required CreateProductBarcodeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.value = valueDes;
          break;
        case r'isActive':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateProductBarcodeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateProductBarcodeRequestBuilder();
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
