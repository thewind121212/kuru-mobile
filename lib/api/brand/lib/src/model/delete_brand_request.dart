//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_brand_request.g.dart';

/// DeleteBrandRequest
///
/// Properties:
/// * [brandId] 
@BuiltValue()
abstract class DeleteBrandRequest implements Built<DeleteBrandRequest, DeleteBrandRequestBuilder> {
  @BuiltValueField(wireName: r'brandId')
  String get brandId;

  DeleteBrandRequest._();

  factory DeleteBrandRequest([void updates(DeleteBrandRequestBuilder b)]) = _$DeleteBrandRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteBrandRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteBrandRequest> get serializer => _$DeleteBrandRequestSerializer();
}

class _$DeleteBrandRequestSerializer implements PrimitiveSerializer<DeleteBrandRequest> {
  @override
  final Iterable<Type> types = const [DeleteBrandRequest, _$DeleteBrandRequest];

  @override
  final String wireName = r'DeleteBrandRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteBrandRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'brandId';
    yield serializers.serialize(
      object.brandId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteBrandRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteBrandRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'brandId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.brandId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteBrandRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteBrandRequestBuilder();
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

