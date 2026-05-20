//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_product_overview_request.g.dart';

/// GetProductOverviewRequest
///
/// Properties:
/// * [searchString] 
/// * [categoryIds] 
/// * [distributorIds] 
/// * [page] 
/// * [limit] 
/// * [warehouseIds] 
/// * [attributeFilters] 
/// * [minPrice] 
/// * [maxPrice] 
/// * [brandIds] 
@BuiltValue()
abstract class GetProductOverviewRequest implements Built<GetProductOverviewRequest, GetProductOverviewRequestBuilder> {
  @BuiltValueField(wireName: r'searchString')
  String? get searchString;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String>? get categoryIds;

  @BuiltValueField(wireName: r'distributorIds')
  BuiltList<String>? get distributorIds;

  @BuiltValueField(wireName: r'page')
  int? get page;

  @BuiltValueField(wireName: r'limit')
  int? get limit;

  @BuiltValueField(wireName: r'warehouseIds')
  BuiltList<String>? get warehouseIds;

  @BuiltValueField(wireName: r'attributeFilters')
  BuiltList<String>? get attributeFilters;

  @BuiltValueField(wireName: r'minPrice')
  double? get minPrice;

  @BuiltValueField(wireName: r'maxPrice')
  double? get maxPrice;

  @BuiltValueField(wireName: r'brandIds')
  BuiltList<String>? get brandIds;

  GetProductOverviewRequest._();

  factory GetProductOverviewRequest([void updates(GetProductOverviewRequestBuilder b)]) = _$GetProductOverviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProductOverviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProductOverviewRequest> get serializer => _$GetProductOverviewRequestSerializer();
}

class _$GetProductOverviewRequestSerializer implements PrimitiveSerializer<GetProductOverviewRequest> {
  @override
  final Iterable<Type> types = const [GetProductOverviewRequest, _$GetProductOverviewRequest];

  @override
  final String wireName = r'GetProductOverviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProductOverviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.searchString != null) {
      yield r'searchString';
      yield serializers.serialize(
        object.searchString,
        specifiedType: const FullType(String),
      );
    }
    if (object.categoryIds != null) {
      yield r'categoryIds';
      yield serializers.serialize(
        object.categoryIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.distributorIds != null) {
      yield r'distributorIds';
      yield serializers.serialize(
        object.distributorIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    if (object.warehouseIds != null) {
      yield r'warehouseIds';
      yield serializers.serialize(
        object.warehouseIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.attributeFilters != null) {
      yield r'attributeFilters';
      yield serializers.serialize(
        object.attributeFilters,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.minPrice != null) {
      yield r'minPrice';
      yield serializers.serialize(
        object.minPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.maxPrice != null) {
      yield r'maxPrice';
      yield serializers.serialize(
        object.maxPrice,
        specifiedType: const FullType(double),
      );
    }
    if (object.brandIds != null) {
      yield r'brandIds';
      yield serializers.serialize(
        object.brandIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetProductOverviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetProductOverviewRequestBuilder result,
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
        case r'categoryIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        case r'distributorIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.distributorIds.replace(valueDes);
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
        case r'warehouseIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.warehouseIds.replace(valueDes);
          break;
        case r'attributeFilters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.attributeFilters.replace(valueDes);
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.minPrice = valueDes;
          break;
        case r'maxPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.maxPrice = valueDes;
          break;
        case r'brandIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.brandIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetProductOverviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProductOverviewRequestBuilder();
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

