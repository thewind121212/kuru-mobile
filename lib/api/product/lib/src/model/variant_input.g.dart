// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VariantInput extends VariantInput {
  @override
  final String? id;
  @override
  final String name;
  @override
  final double? sellPrice;
  @override
  final double? exportPrice;
  @override
  final double? importPrice;
  @override
  final BuiltMap<String, String> attributes;
  @override
  final String? barcode;
  @override
  final String? imageUrl;
  @override
  final BuiltList<String>? attributeValueIds;

  factory _$VariantInput([void Function(VariantInputBuilder)? updates]) =>
      (VariantInputBuilder()..update(updates))._build();

  _$VariantInput._({
    this.id,
    required this.name,
    this.sellPrice,
    this.exportPrice,
    this.importPrice,
    required this.attributes,
    this.barcode,
    this.imageUrl,
    this.attributeValueIds,
  }) : super._();
  @override
  VariantInput rebuild(void Function(VariantInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VariantInputBuilder toBuilder() => VariantInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VariantInput &&
        id == other.id &&
        name == other.name &&
        sellPrice == other.sellPrice &&
        exportPrice == other.exportPrice &&
        importPrice == other.importPrice &&
        attributes == other.attributes &&
        barcode == other.barcode &&
        imageUrl == other.imageUrl &&
        attributeValueIds == other.attributeValueIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, attributeValueIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VariantInput')
          ..add('id', id)
          ..add('name', name)
          ..add('sellPrice', sellPrice)
          ..add('exportPrice', exportPrice)
          ..add('importPrice', importPrice)
          ..add('attributes', attributes)
          ..add('barcode', barcode)
          ..add('imageUrl', imageUrl)
          ..add('attributeValueIds', attributeValueIds))
        .toString();
  }
}

class VariantInputBuilder
    implements Builder<VariantInput, VariantInputBuilder> {
  _$VariantInput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  double? _exportPrice;
  double? get exportPrice => _$this._exportPrice;
  set exportPrice(double? exportPrice) => _$this._exportPrice = exportPrice;

  double? _importPrice;
  double? get importPrice => _$this._importPrice;
  set importPrice(double? importPrice) => _$this._importPrice = importPrice;

  MapBuilder<String, String>? _attributes;
  MapBuilder<String, String> get attributes =>
      _$this._attributes ??= MapBuilder<String, String>();
  set attributes(MapBuilder<String, String>? attributes) =>
      _$this._attributes = attributes;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  ListBuilder<String>? _attributeValueIds;
  ListBuilder<String> get attributeValueIds =>
      _$this._attributeValueIds ??= ListBuilder<String>();
  set attributeValueIds(ListBuilder<String>? attributeValueIds) =>
      _$this._attributeValueIds = attributeValueIds;

  VariantInputBuilder() {
    VariantInput._defaults(this);
  }

  VariantInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _sellPrice = $v.sellPrice;
      _exportPrice = $v.exportPrice;
      _importPrice = $v.importPrice;
      _attributes = $v.attributes.toBuilder();
      _barcode = $v.barcode;
      _imageUrl = $v.imageUrl;
      _attributeValueIds = $v.attributeValueIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VariantInput other) {
    _$v = other as _$VariantInput;
  }

  @override
  void update(void Function(VariantInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VariantInput build() => _build();

  _$VariantInput _build() {
    _$VariantInput _$result;
    try {
      _$result =
          _$v ??
          _$VariantInput._(
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'VariantInput',
              'name',
            ),
            sellPrice: sellPrice,
            exportPrice: exportPrice,
            importPrice: importPrice,
            attributes: attributes.build(),
            barcode: barcode,
            imageUrl: imageUrl,
            attributeValueIds: _attributeValueIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();

        _$failedField = 'attributeValueIds';
        _attributeValueIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'VariantInput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
