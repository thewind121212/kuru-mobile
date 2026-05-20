// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_pack_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductPackRequest extends CreateProductPackRequest {
  @override
  final String name;
  @override
  final int multiplier;
  @override
  final BuiltList<CreateProductBarcodeRequest>? barcodes;
  @override
  final double? sellPrice;

  factory _$CreateProductPackRequest([
    void Function(CreateProductPackRequestBuilder)? updates,
  ]) => (CreateProductPackRequestBuilder()..update(updates))._build();

  _$CreateProductPackRequest._({
    required this.name,
    required this.multiplier,
    this.barcodes,
    this.sellPrice,
  }) : super._();
  @override
  CreateProductPackRequest rebuild(
    void Function(CreateProductPackRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductPackRequestBuilder toBuilder() =>
      CreateProductPackRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductPackRequest &&
        name == other.name &&
        multiplier == other.multiplier &&
        barcodes == other.barcodes &&
        sellPrice == other.sellPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, multiplier.hashCode);
    _$hash = $jc(_$hash, barcodes.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductPackRequest')
          ..add('name', name)
          ..add('multiplier', multiplier)
          ..add('barcodes', barcodes)
          ..add('sellPrice', sellPrice))
        .toString();
  }
}

class CreateProductPackRequestBuilder
    implements
        Builder<CreateProductPackRequest, CreateProductPackRequestBuilder> {
  _$CreateProductPackRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _multiplier;
  int? get multiplier => _$this._multiplier;
  set multiplier(int? multiplier) => _$this._multiplier = multiplier;

  ListBuilder<CreateProductBarcodeRequest>? _barcodes;
  ListBuilder<CreateProductBarcodeRequest> get barcodes =>
      _$this._barcodes ??= ListBuilder<CreateProductBarcodeRequest>();
  set barcodes(ListBuilder<CreateProductBarcodeRequest>? barcodes) =>
      _$this._barcodes = barcodes;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  CreateProductPackRequestBuilder() {
    CreateProductPackRequest._defaults(this);
  }

  CreateProductPackRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _multiplier = $v.multiplier;
      _barcodes = $v.barcodes?.toBuilder();
      _sellPrice = $v.sellPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductPackRequest other) {
    _$v = other as _$CreateProductPackRequest;
  }

  @override
  void update(void Function(CreateProductPackRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductPackRequest build() => _build();

  _$CreateProductPackRequest _build() {
    _$CreateProductPackRequest _$result;
    try {
      _$result =
          _$v ??
          _$CreateProductPackRequest._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CreateProductPackRequest',
              'name',
            ),
            multiplier: BuiltValueNullFieldError.checkNotNull(
              multiplier,
              r'CreateProductPackRequest',
              'multiplier',
            ),
            barcodes: _barcodes?.build(),
            sellPrice: sellPrice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'barcodes';
        _barcodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreateProductPackRequest',
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
