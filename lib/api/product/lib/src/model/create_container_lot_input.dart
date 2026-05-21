//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_container_lot_input.g.dart';

/// CreateContainerLotInput
///
/// Properties:
/// * [warehouseId]
/// * [qtyInitial]
/// * [qtyRemaining]
/// * [barcode]
/// * [variantId]
@BuiltValue()
abstract class CreateContainerLotInput
    implements Built<CreateContainerLotInput, CreateContainerLotInputBuilder> {
  @BuiltValueField(wireName: r'warehouseId')
  String get warehouseId;

  @BuiltValueField(wireName: r'qtyInitial')
  double get qtyInitial;

  @BuiltValueField(wireName: r'qtyRemaining')
  double? get qtyRemaining;

  @BuiltValueField(wireName: r'barcode')
  String? get barcode;

  @BuiltValueField(wireName: r'variantId')
  String? get variantId;

  CreateContainerLotInput._();

  factory CreateContainerLotInput([
    void updates(CreateContainerLotInputBuilder b),
  ]) = _$CreateContainerLotInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateContainerLotInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateContainerLotInput> get serializer =>
      _$CreateContainerLotInputSerializer();
}

class _$CreateContainerLotInputSerializer
    implements PrimitiveSerializer<CreateContainerLotInput> {
  @override
  final Iterable<Type> types = const [
    CreateContainerLotInput,
    _$CreateContainerLotInput,
  ];

  @override
  final String wireName = r'CreateContainerLotInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateContainerLotInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'warehouseId';
    yield serializers.serialize(
      object.warehouseId,
      specifiedType: const FullType(String),
    );
    yield r'qtyInitial';
    yield serializers.serialize(
      object.qtyInitial,
      specifiedType: const FullType(double),
    );
    if (object.qtyRemaining != null) {
      yield r'qtyRemaining';
      yield serializers.serialize(
        object.qtyRemaining,
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
    if (object.variantId != null) {
      yield r'variantId';
      yield serializers.serialize(
        object.variantId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateContainerLotInput object, {
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
    required CreateContainerLotInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'warehouseId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.warehouseId = valueDes;
          break;
        case r'qtyInitial':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.qtyInitial = valueDes;
          break;
        case r'qtyRemaining':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double;
          result.qtyRemaining = valueDes;
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
        case r'variantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.variantId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateContainerLotInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateContainerLotInputBuilder();
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
