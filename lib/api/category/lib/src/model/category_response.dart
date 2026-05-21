//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'category_response.g.dart';

/// CategoryResponse
///
/// Properties:
/// * [categoryId]
/// * [name]
/// * [parentId]
/// * [parentName]
/// * [description]
/// * [colorSettings]
/// * [layer]
/// * [icon]
/// * [subCategoriesCount]
/// * [status]
/// * [orgId]
/// * [itemCount]
/// * [totalValue]
/// * [lowStockCount]
@BuiltValue()
abstract class CategoryResponse
    implements Built<CategoryResponse, CategoryResponseBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  @BuiltValueField(wireName: r'parentName')
  String? get parentName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'colorSettings')
  String? get colorSettings;

  @BuiltValueField(wireName: r'layer')
  String? get layer;

  @BuiltValueField(wireName: r'icon')
  String? get icon;

  @BuiltValueField(wireName: r'subCategoriesCount')
  int? get subCategoriesCount;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'orgId')
  String get orgId;

  @BuiltValueField(wireName: r'itemCount')
  int get itemCount;

  @BuiltValueField(wireName: r'totalValue')
  num get totalValue;

  @BuiltValueField(wireName: r'lowStockCount')
  int get lowStockCount;

  CategoryResponse._();

  factory CategoryResponse([void updates(CategoryResponseBuilder b)]) =
      _$CategoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CategoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CategoryResponse> get serializer =>
      _$CategoryResponseSerializer();
}

class _$CategoryResponseSerializer
    implements PrimitiveSerializer<CategoryResponse> {
  @override
  final Iterable<Type> types = const [CategoryResponse, _$CategoryResponse];

  @override
  final String wireName = r'CategoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CategoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType(String),
      );
    }
    if (object.parentName != null) {
      yield r'parentName';
      yield serializers.serialize(
        object.parentName,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.colorSettings != null) {
      yield r'colorSettings';
      yield serializers.serialize(
        object.colorSettings,
        specifiedType: const FullType(String),
      );
    }
    if (object.layer != null) {
      yield r'layer';
      yield serializers.serialize(
        object.layer,
        specifiedType: const FullType(String),
      );
    }
    if (object.icon != null) {
      yield r'icon';
      yield serializers.serialize(
        object.icon,
        specifiedType: const FullType(String),
      );
    }
    if (object.subCategoriesCount != null) {
      yield r'subCategoriesCount';
      yield serializers.serialize(
        object.subCategoriesCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    yield r'orgId';
    yield serializers.serialize(
      object.orgId,
      specifiedType: const FullType(String),
    );
    yield r'itemCount';
    yield serializers.serialize(
      object.itemCount,
      specifiedType: const FullType(int),
    );
    yield r'totalValue';
    yield serializers.serialize(
      object.totalValue,
      specifiedType: const FullType(num),
    );
    yield r'lowStockCount';
    yield serializers.serialize(
      object.lowStockCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CategoryResponse object, {
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
    required CategoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
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
        case r'parentId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.parentId = valueDes;
          break;
        case r'parentName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.parentName = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        case r'colorSettings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.colorSettings = valueDes;
          break;
        case r'layer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.layer = valueDes;
          break;
        case r'icon':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.icon = valueDes;
          break;
        case r'subCategoriesCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.subCategoriesCount = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.status = valueDes;
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
        case r'itemCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.itemCount = valueDes;
          break;
        case r'totalValue':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.totalValue = valueDes;
          break;
        case r'lowStockCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.lowStockCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CategoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CategoryResponseBuilder();
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
