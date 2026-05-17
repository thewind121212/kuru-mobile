// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCategoryRequest extends CreateCategoryRequest {
  @override
  final String name;
  @override
  final String? parentId;
  @override
  final String? colorSettings;
  @override
  final String layer;
  @override
  final String? description;
  @override
  final String status;
  @override
  final String? icon;

  factory _$CreateCategoryRequest(
          [void Function(CreateCategoryRequestBuilder)? updates]) =>
      (CreateCategoryRequestBuilder()..update(updates))._build();

  _$CreateCategoryRequest._(
      {required this.name,
      this.parentId,
      this.colorSettings,
      required this.layer,
      this.description,
      required this.status,
      this.icon})
      : super._();
  @override
  CreateCategoryRequest rebuild(
          void Function(CreateCategoryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCategoryRequestBuilder toBuilder() =>
      CreateCategoryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCategoryRequest &&
        name == other.name &&
        parentId == other.parentId &&
        colorSettings == other.colorSettings &&
        layer == other.layer &&
        description == other.description &&
        status == other.status &&
        icon == other.icon;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, colorSettings.hashCode);
    _$hash = $jc(_$hash, layer.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCategoryRequest')
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('colorSettings', colorSettings)
          ..add('layer', layer)
          ..add('description', description)
          ..add('status', status)
          ..add('icon', icon))
        .toString();
  }
}

class CreateCategoryRequestBuilder
    implements Builder<CreateCategoryRequest, CreateCategoryRequestBuilder> {
  _$CreateCategoryRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  String? _colorSettings;
  String? get colorSettings => _$this._colorSettings;
  set colorSettings(String? colorSettings) =>
      _$this._colorSettings = colorSettings;

  String? _layer;
  String? get layer => _$this._layer;
  set layer(String? layer) => _$this._layer = layer;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  CreateCategoryRequestBuilder() {
    CreateCategoryRequest._defaults(this);
  }

  CreateCategoryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _parentId = $v.parentId;
      _colorSettings = $v.colorSettings;
      _layer = $v.layer;
      _description = $v.description;
      _status = $v.status;
      _icon = $v.icon;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCategoryRequest other) {
    _$v = other as _$CreateCategoryRequest;
  }

  @override
  void update(void Function(CreateCategoryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCategoryRequest build() => _build();

  _$CreateCategoryRequest _build() {
    final _$result = _$v ??
        _$CreateCategoryRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateCategoryRequest', 'name'),
          parentId: parentId,
          colorSettings: colorSettings,
          layer: BuiltValueNullFieldError.checkNotNull(
              layer, r'CreateCategoryRequest', 'layer'),
          description: description,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CreateCategoryRequest', 'status'),
          icon: icon,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
