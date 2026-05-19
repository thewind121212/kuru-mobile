//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:kuru_brand_api/src/model/brand_overview_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_brand_overview_response.g.dart';

/// GetBrandOverviewResponse
///
/// Properties:
/// * [brands] 
/// * [total] 
/// * [page] 
/// * [limit] 
@BuiltValue()
abstract class GetBrandOverviewResponse implements Built<GetBrandOverviewResponse, GetBrandOverviewResponseBuilder> {
  @BuiltValueField(wireName: r'brands')
  BuiltList<BrandOverviewItem>? get brands;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  GetBrandOverviewResponse._();

  factory GetBrandOverviewResponse([void updates(GetBrandOverviewResponseBuilder b)]) = _$GetBrandOverviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetBrandOverviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetBrandOverviewResponse> get serializer => _$GetBrandOverviewResponseSerializer();
}

class _$GetBrandOverviewResponseSerializer implements PrimitiveSerializer<GetBrandOverviewResponse> {
  @override
  final Iterable<Type> types = const [GetBrandOverviewResponse, _$GetBrandOverviewResponse];

  @override
  final String wireName = r'GetBrandOverviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetBrandOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.brands != null) {
      yield r'brands';
      yield serializers.serialize(
        object.brands,
        specifiedType: const FullType(BuiltList, [FullType(BrandOverviewItem)]),
      );
    }
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetBrandOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetBrandOverviewResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'brands':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BrandOverviewItem)]),
          ) as BuiltList<BrandOverviewItem>;
          result.brands.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
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
  GetBrandOverviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetBrandOverviewResponseBuilder();
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

