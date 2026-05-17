// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CategoryResponse extends CategoryResponse {
  @override
  final String? categoryId;
  @override
  final String? name;
  @override
  final String? parentId;
  @override
  final String? parentName;
  @override
  final String? description;
  @override
  final String? colorSettings;
  @override
  final String? layer;
  @override
  final String? icon;
  @override
  final int? subCategoriesCount;
  @override
  final String? status;
  @override
  final String orgId;
  @override
  final int itemCount;
  @override
  final num totalValue;
  @override
  final int lowStockCount;

  factory _$CategoryResponse(
          [void Function(CategoryResponseBuilder)? updates]) =>
      (CategoryResponseBuilder()..update(updates))._build();

  _$CategoryResponse._(
      {this.categoryId,
      this.name,
      this.parentId,
      this.parentName,
      this.description,
      this.colorSettings,
      this.layer,
      this.icon,
      this.subCategoriesCount,
      this.status,
      required this.orgId,
      required this.itemCount,
      required this.totalValue,
      required this.lowStockCount})
      : super._();
  @override
  CategoryResponse rebuild(void Function(CategoryResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryResponseBuilder toBuilder() =>
      CategoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryResponse &&
        categoryId == other.categoryId &&
        name == other.name &&
        parentId == other.parentId &&
        parentName == other.parentName &&
        description == other.description &&
        colorSettings == other.colorSettings &&
        layer == other.layer &&
        icon == other.icon &&
        subCategoriesCount == other.subCategoriesCount &&
        status == other.status &&
        orgId == other.orgId &&
        itemCount == other.itemCount &&
        totalValue == other.totalValue &&
        lowStockCount == other.lowStockCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, parentName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, colorSettings.hashCode);
    _$hash = $jc(_$hash, layer.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, subCategoriesCount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, itemCount.hashCode);
    _$hash = $jc(_$hash, totalValue.hashCode);
    _$hash = $jc(_$hash, lowStockCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CategoryResponse')
          ..add('categoryId', categoryId)
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('parentName', parentName)
          ..add('description', description)
          ..add('colorSettings', colorSettings)
          ..add('layer', layer)
          ..add('icon', icon)
          ..add('subCategoriesCount', subCategoriesCount)
          ..add('status', status)
          ..add('orgId', orgId)
          ..add('itemCount', itemCount)
          ..add('totalValue', totalValue)
          ..add('lowStockCount', lowStockCount))
        .toString();
  }
}

class CategoryResponseBuilder
    implements Builder<CategoryResponse, CategoryResponseBuilder> {
  _$CategoryResponse? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  String? _parentName;
  String? get parentName => _$this._parentName;
  set parentName(String? parentName) => _$this._parentName = parentName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _colorSettings;
  String? get colorSettings => _$this._colorSettings;
  set colorSettings(String? colorSettings) =>
      _$this._colorSettings = colorSettings;

  String? _layer;
  String? get layer => _$this._layer;
  set layer(String? layer) => _$this._layer = layer;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  int? _subCategoriesCount;
  int? get subCategoriesCount => _$this._subCategoriesCount;
  set subCategoriesCount(int? subCategoriesCount) =>
      _$this._subCategoriesCount = subCategoriesCount;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  int? _itemCount;
  int? get itemCount => _$this._itemCount;
  set itemCount(int? itemCount) => _$this._itemCount = itemCount;

  num? _totalValue;
  num? get totalValue => _$this._totalValue;
  set totalValue(num? totalValue) => _$this._totalValue = totalValue;

  int? _lowStockCount;
  int? get lowStockCount => _$this._lowStockCount;
  set lowStockCount(int? lowStockCount) =>
      _$this._lowStockCount = lowStockCount;

  CategoryResponseBuilder() {
    CategoryResponse._defaults(this);
  }

  CategoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _name = $v.name;
      _parentId = $v.parentId;
      _parentName = $v.parentName;
      _description = $v.description;
      _colorSettings = $v.colorSettings;
      _layer = $v.layer;
      _icon = $v.icon;
      _subCategoriesCount = $v.subCategoriesCount;
      _status = $v.status;
      _orgId = $v.orgId;
      _itemCount = $v.itemCount;
      _totalValue = $v.totalValue;
      _lowStockCount = $v.lowStockCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoryResponse other) {
    _$v = other as _$CategoryResponse;
  }

  @override
  void update(void Function(CategoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoryResponse build() => _build();

  _$CategoryResponse _build() {
    final _$result = _$v ??
        _$CategoryResponse._(
          categoryId: categoryId,
          name: name,
          parentId: parentId,
          parentName: parentName,
          description: description,
          colorSettings: colorSettings,
          layer: layer,
          icon: icon,
          subCategoriesCount: subCategoriesCount,
          status: status,
          orgId: BuiltValueNullFieldError.checkNotNull(
              orgId, r'CategoryResponse', 'orgId'),
          itemCount: BuiltValueNullFieldError.checkNotNull(
              itemCount, r'CategoryResponse', 'itemCount'),
          totalValue: BuiltValueNullFieldError.checkNotNull(
              totalValue, r'CategoryResponse', 'totalValue'),
          lowStockCount: BuiltValueNullFieldError.checkNotNull(
              lowStockCount, r'CategoryResponse', 'lowStockCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
