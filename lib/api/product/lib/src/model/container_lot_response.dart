//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'container_lot_response.g.dart';

/// ContainerLotResponse
///
/// Properties:
/// * [id]
/// * [orgId]
/// * [warehouseId]
/// * [productId]
/// * [qtyInitial]
/// * [qtyRemaining]
/// * [barcode]
/// * [variantId]
/// * [variantName]
/// * [createdAt]
@BuiltValue()
abstract class ContainerLotResponse
    implements Built<ContainerLotResponse, ContainerLotResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'warehouseId')
  String get warehouseId;

  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'qtyInitial')
  double get qtyInitial;

  @BuiltValueField(wireName: r'qtyRemaining')
  double get qtyRemaining;

  @BuiltValueField(wireName: r'barcode')
  String? get barcode;

  @BuiltValueField(wireName: r'variantId')
  String? get variantId;

  @BuiltValueField(wireName: r'variantName')
  String? get variantName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ContainerLotResponse._();

  factory ContainerLotResponse([void updates(ContainerLotResponseBuilder b)]) =
      _$ContainerLotResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContainerLotResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContainerLotResponse> get serializer =>
      _$ContainerLotResponseSerializer();
}

class _$ContainerLotResponseSerializer
    implements PrimitiveSerializer<ContainerLotResponse> {
  @override
  final Iterable<Type> types = const [
    ContainerLotResponse,
    _$ContainerLotResponse,
  ];

  @override
  final String wireName = r'ContainerLotResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContainerLotResponse object, {
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
    yield r'warehouseId';
    yield serializers.serialize(
      object.warehouseId,
      specifiedType: const FullType(String),
    );
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    yield r'qtyInitial';
    yield serializers.serialize(
      object.qtyInitial,
      specifiedType: const FullType(double),
    );
    yield r'qtyRemaining';
    yield serializers.serialize(
      object.qtyRemaining,
      specifiedType: const FullType(double),
    );
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
    if (object.variantName != null) {
      yield r'variantName';
      yield serializers.serialize(
        object.variantName,
        specifiedType: const FullType(String),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContainerLotResponse object, {
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
    required ContainerLotResponseBuilder result,
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
        case r'orgId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orgId = valueDes;
          break;
        case r'warehouseId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.warehouseId = valueDes;
          break;
        case r'productId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.productId = valueDes;
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
        case r'variantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.variantName = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContainerLotResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContainerLotResponseBuilder();
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
