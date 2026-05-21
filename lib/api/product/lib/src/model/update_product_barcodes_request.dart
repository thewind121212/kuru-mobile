//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:kuru_product_api/src/model/upsert_barcode_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_product_barcodes_request.g.dart';

/// UpdateProductBarcodesRequest
///
/// Properties:
/// * [productId]
/// * [upsertBarcodes]
/// * [removeBarcodeIds]
@BuiltValue()
abstract class UpdateProductBarcodesRequest
    implements
        Built<
          UpdateProductBarcodesRequest,
          UpdateProductBarcodesRequestBuilder
        > {
  @BuiltValueField(wireName: r'productId')
  String get productId;

  @BuiltValueField(wireName: r'upsertBarcodes')
  BuiltList<UpsertBarcodeInput>? get upsertBarcodes;

  @BuiltValueField(wireName: r'removeBarcodeIds')
  BuiltList<String>? get removeBarcodeIds;

  UpdateProductBarcodesRequest._();

  factory UpdateProductBarcodesRequest([
    void updates(UpdateProductBarcodesRequestBuilder b),
  ]) = _$UpdateProductBarcodesRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProductBarcodesRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProductBarcodesRequest> get serializer =>
      _$UpdateProductBarcodesRequestSerializer();
}

class _$UpdateProductBarcodesRequestSerializer
    implements PrimitiveSerializer<UpdateProductBarcodesRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateProductBarcodesRequest,
    _$UpdateProductBarcodesRequest,
  ];

  @override
  final String wireName = r'UpdateProductBarcodesRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProductBarcodesRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(String),
    );
    if (object.upsertBarcodes != null) {
      yield r'upsertBarcodes';
      yield serializers.serialize(
        object.upsertBarcodes,
        specifiedType: const FullType(BuiltList, [
          FullType(UpsertBarcodeInput),
        ]),
      );
    }
    if (object.removeBarcodeIds != null) {
      yield r'removeBarcodeIds';
      yield serializers.serialize(
        object.removeBarcodeIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProductBarcodesRequest object, {
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
    required UpdateProductBarcodesRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.productId = valueDes;
          break;
        case r'upsertBarcodes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(UpsertBarcodeInput),
                    ]),
                  )
                  as BuiltList<UpsertBarcodeInput>;
          result.upsertBarcodes.replace(valueDes);
          break;
        case r'removeBarcodeIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.removeBarcodeIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProductBarcodesRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProductBarcodesRequestBuilder();
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
