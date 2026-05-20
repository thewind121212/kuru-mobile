//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upsert_umo_input.g.dart';

/// UpsertUmoInput
///
/// Properties:
/// * [id] 
/// * [label] 
/// * [ratio] 
/// * [sellPrice] 
/// * [barcode] 
@BuiltValue()
abstract class UpsertUmoInput implements Built<UpsertUmoInput, UpsertUmoInputBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'ratio')
  int get ratio;

  @BuiltValueField(wireName: r'sellPrice')
  double? get sellPrice;

  @BuiltValueField(wireName: r'barcode')
  String? get barcode;

  UpsertUmoInput._();

  factory UpsertUmoInput([void updates(UpsertUmoInputBuilder b)]) = _$UpsertUmoInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpsertUmoInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpsertUmoInput> get serializer => _$UpsertUmoInputSerializer();
}

class _$UpsertUmoInputSerializer implements PrimitiveSerializer<UpsertUmoInput> {
  @override
  final Iterable<Type> types = const [UpsertUmoInput, _$UpsertUmoInput];

  @override
  final String wireName = r'UpsertUmoInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpsertUmoInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    yield r'label';
    yield serializers.serialize(
      object.label,
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
    if (object.barcode != null) {
      yield r'barcode';
      yield serializers.serialize(
        object.barcode,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpsertUmoInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpsertUmoInputBuilder result,
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
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'ratio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratio = valueDes;
          break;
        case r'sellPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.sellPrice = valueDes;
          break;
        case r'barcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  UpsertUmoInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpsertUmoInputBuilder();
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

