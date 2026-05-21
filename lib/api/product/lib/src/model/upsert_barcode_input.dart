//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upsert_barcode_input.g.dart';

/// UpsertBarcodeInput
///
/// Properties:
/// * [id]
/// * [barcode]
@BuiltValue()
abstract class UpsertBarcodeInput
    implements Built<UpsertBarcodeInput, UpsertBarcodeInputBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'barcode')
  String get barcode;

  UpsertBarcodeInput._();

  factory UpsertBarcodeInput([void updates(UpsertBarcodeInputBuilder b)]) =
      _$UpsertBarcodeInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpsertBarcodeInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpsertBarcodeInput> get serializer =>
      _$UpsertBarcodeInputSerializer();
}

class _$UpsertBarcodeInputSerializer
    implements PrimitiveSerializer<UpsertBarcodeInput> {
  @override
  final Iterable<Type> types = const [UpsertBarcodeInput, _$UpsertBarcodeInput];

  @override
  final String wireName = r'UpsertBarcodeInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpsertBarcodeInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    yield r'barcode';
    yield serializers.serialize(
      object.barcode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpsertBarcodeInput object, {
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
    required UpsertBarcodeInputBuilder result,
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
        case r'barcode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.barcode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpsertBarcodeInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpsertBarcodeInputBuilder();
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
