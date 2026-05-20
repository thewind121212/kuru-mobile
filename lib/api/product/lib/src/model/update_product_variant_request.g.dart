// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_variant_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductVariantRequest extends UpdateProductVariantRequest {
  @override
  final String variantId;
  @override
  final String? name;
  @override
  final double? sellPrice;
  @override
  final double? exportPrice;
  @override
  final double? importPrice;
  @override
  final String? barcode;
  @override
  final BuiltMap<String, String> attributes;

  factory _$UpdateProductVariantRequest([
    void Function(UpdateProductVariantRequestBuilder)? updates,
  ]) => (UpdateProductVariantRequestBuilder()..update(updates))._build();

  _$UpdateProductVariantRequest._({
    required this.variantId,
    this.name,
    this.sellPrice,
    this.exportPrice,
    this.importPrice,
    this.barcode,
    required this.attributes,
  }) : super._();
  @override
  UpdateProductVariantRequest rebuild(
    void Function(UpdateProductVariantRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductVariantRequestBuilder toBuilder() =>
      UpdateProductVariantRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductVariantRequest &&
        variantId == other.variantId &&
        name == other.name &&
        sellPrice == other.sellPrice &&
        exportPrice == other.exportPrice &&
        importPrice == other.importPrice &&
        barcode == other.barcode &&
        attributes == other.attributes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, exportPrice.hashCode);
    _$hash = $jc(_$hash, importPrice.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateProductVariantRequest')
          ..add('variantId', variantId)
          ..add('name', name)
          ..add('sellPrice', sellPrice)
          ..add('exportPrice', exportPrice)
          ..add('importPrice', importPrice)
          ..add('barcode', barcode)
          ..add('attributes', attributes))
        .toString();
  }
}

class UpdateProductVariantRequestBuilder
    implements
        Builder<
          UpdateProductVariantRequest,
          UpdateProductVariantRequestBuilder
        > {
  _$UpdateProductVariantRequest? _$v;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

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

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  MapBuilder<String, String>? _attributes;
  MapBuilder<String, String> get attributes =>
      _$this._attributes ??= MapBuilder<String, String>();
  set attributes(MapBuilder<String, String>? attributes) =>
      _$this._attributes = attributes;

  UpdateProductVariantRequestBuilder() {
    UpdateProductVariantRequest._defaults(this);
  }

  UpdateProductVariantRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variantId = $v.variantId;
      _name = $v.name;
      _sellPrice = $v.sellPrice;
      _exportPrice = $v.exportPrice;
      _importPrice = $v.importPrice;
      _barcode = $v.barcode;
      _attributes = $v.attributes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProductVariantRequest other) {
    _$v = other as _$UpdateProductVariantRequest;
  }

  @override
  void update(void Function(UpdateProductVariantRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductVariantRequest build() => _build();

  _$UpdateProductVariantRequest _build() {
    _$UpdateProductVariantRequest _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductVariantRequest._(
            variantId: BuiltValueNullFieldError.checkNotNull(
              variantId,
              r'UpdateProductVariantRequest',
              'variantId',
            ),
            name: name,
            sellPrice: sellPrice,
            exportPrice: exportPrice,
            importPrice: importPrice,
            barcode: barcode,
            attributes: attributes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateProductVariantRequest',
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
