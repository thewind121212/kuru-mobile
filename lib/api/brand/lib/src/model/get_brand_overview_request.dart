//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_brand_overview_request.g.dart';

/// GetBrandOverviewRequest
///
/// Properties:
/// * [searchString] 
/// * [page] 
/// * [limit] 
@BuiltValue()
abstract class GetBrandOverviewRequest implements Built<GetBrandOverviewRequest, GetBrandOverviewRequestBuilder> {
  @BuiltValueField(wireName: r'searchString')
  String? get searchString;

  @BuiltValueField(wireName: r'page')
  int? get page;

  @BuiltValueField(wireName: r'limit')
  int? get limit;

  GetBrandOverviewRequest._();

  factory GetBrandOverviewRequest([void updates(GetBrandOverviewRequestBuilder b)]) = _$GetBrandOverviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetBrandOverviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetBrandOverviewRequest> get serializer => _$GetBrandOverviewRequestSerializer();
}

class _$GetBrandOverviewRequestSerializer implements PrimitiveSerializer<GetBrandOverviewRequest> {
  @override
  final Iterable<Type> types = const [GetBrandOverviewRequest, _$GetBrandOverviewRequest];

  @override
  final String wireName = r'GetBrandOverviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetBrandOverviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.searchString != null) {
      yield r'searchString';
      yield serializers.serialize(
        object.searchString,
        specifiedType: const FullType(String),
      );
    }
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
      );
    }
    if (object.limit != null) {
      yield r'limit';
      yield serializers.serialize(
        object.limit,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetBrandOverviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetBrandOverviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'searchString':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.searchString = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetBrandOverviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetBrandOverviewRequestBuilder();
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

