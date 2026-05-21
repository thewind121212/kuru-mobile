//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_brand_request.g.dart';

/// UpdateBrandRequest
///
/// Properties:
/// * [brandId]
/// * [name]
/// * [slug]
/// * [logoUrl]
@BuiltValue()
abstract class UpdateBrandRequest
    implements Built<UpdateBrandRequest, UpdateBrandRequestBuilder> {
  @BuiltValueField(wireName: r'brandId')
  String get brandId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  UpdateBrandRequest._();

  factory UpdateBrandRequest([void updates(UpdateBrandRequestBuilder b)]) =
      _$UpdateBrandRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateBrandRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateBrandRequest> get serializer =>
      _$UpdateBrandRequestSerializer();
}

class _$UpdateBrandRequestSerializer
    implements PrimitiveSerializer<UpdateBrandRequest> {
  @override
  final Iterable<Type> types = const [UpdateBrandRequest, _$UpdateBrandRequest];

  @override
  final String wireName = r'UpdateBrandRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateBrandRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'brandId';
    yield serializers.serialize(
      object.brandId,
      specifiedType: const FullType(String),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.slug != null) {
      yield r'slug';
      yield serializers.serialize(
        object.slug,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoUrl != null) {
      yield r'logoUrl';
      yield serializers.serialize(
        object.logoUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateBrandRequest object, {
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
    required UpdateBrandRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'brandId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.brandId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'slug':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.slug = valueDes;
          break;
        case r'logoUrl':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.logoUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateBrandRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateBrandRequestBuilder();
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
